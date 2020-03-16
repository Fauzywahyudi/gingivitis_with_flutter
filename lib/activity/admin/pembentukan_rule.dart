import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/model/modeladmin.dart';
import 'package:gingivitis/activity/admin/detail_rule_fuzzy.dart';

class PembentukanRule extends StatefulWidget {
  PembentukanRule({this.title});
  final String title;

  @override
  _PembentukanRuleState createState() => _PembentukanRuleState();
}

class _PembentukanRuleState extends State<PembentukanRule> {
  ModelminPembentukanRule model = new ModelminPembentukanRule();

  Future<List> getRule(String kata) async {
    if (model.isSearch == false) {
      final result = await http.get(link.LinkSource.getRuleFuzzy);
      return json.decode(result.body);
    } else {
      final result = await http.post(link.LinkSource.searchRule, body: {
        "kata": kata,
      });
      return json.decode(result.body);
    }
  }
  Future<int> addData(String kode_rule) async{

    String msg ;
    if(widget.title=="Pilih Untuk Dilatih"){
      final result = await http.post(link.LinkSource.addDataPelatihan, body: {
        "kode_rule": kode_rule,
      });
      setState(() {
        msg = result.body;
      });
    }else if(widget.title=="Pilih Untuk Diuji"){
      final result = await http.post(link.LinkSource.addDataPengujian, body: {
        "kode_rule": kode_rule,
      });
      setState(() {
        msg = result.body;
      });
    }
    if(msg=="1"){
      Fluttertoast.showToast(msg: '$kode_rule ditambahkan',textColor: Colors.white,backgroundColor: Colors.green);
    }else if(msg=="2"){
      Fluttertoast.showToast(msg: '$kode_rule sudah ada',textColor: Colors.white,backgroundColor: Colors.red);
    }else{
      Fluttertoast.showToast(msg: 'gagal menambahkan',textColor: Colors.white,backgroundColor: Colors.red);
    }

  }

  Future<int> selected(String kode_rule) async{
    String kondisi;
    if(widget.title=="Pilih Untuk Dilatih"){
      setState(() {
        kondisi = "pelatihan";
      });
    }else if(widget.title=="Pilih Untuk Diuji"){
      setState(() {
        kondisi = "pengujian";
      });
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                "Konfirmasi"),
            content: Text("Apakah anda yakin menambahkan $kode_rule ke data $kondisi?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {


                    addData(kode_rule);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Iya",
                    style:
                    TextStyle(color: Colors.green),
                  )),
              FlatButton(
                  onPressed: () =>
                      Navigator.pop(context),
                  child: Text("Tidak",
                      style: TextStyle(
                          color: Colors.red))),
            ],
          );
        });
  }

  Future quickData(String tipe, String jml)async{
    setState(() {
      model.isLoading=true;
    });
    final result = await http.post(link.LinkSource.quickData, body: {
      "tipe": tipe,
      "jml": jml,
    });
    setState(() {
      model.isLoading=false;
    });
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: model.isSearch
            ? TextField(
                controller: model.edc_search,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Cari Rule",
                    hintStyle: TextStyle(color: Colors.white60)),
                onChanged: (v) {
                  setState(() {
                    model.wordSearch = v;
                  });
                },
                autofocus: model.isSearch,
              )
            : Text("${widget.title}"),
        actions: <Widget>[
          model.isSearch
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      model.isSearch = false;
                      model.edc_search.text="";
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      model.isSearch = true;
                    });
                  },
                ),
          widget.title=="Pilih Untuk Dilatih"?
          IconButton(
              icon: new PopupMenuButton(
                tooltip: "More",
                icon: Icon(Icons.more_vert),
                itemBuilder: (_) => <PopupMenuItem<String>>[
                  new PopupMenuItem<String>(
                      child: const Text('20 Data'), value: '20'),
                  new PopupMenuItem<String>(
                      child: const Text('40 Data'), value: '40'),
                  new PopupMenuItem<String>(
                      child: const Text('60 Data'), value: '60'),
                ],
                onSelected: (v){
                  if(v=="20"){
                    quickData("latih", "20");
                  }else if(v=="40"){
                    quickData("latih", "40");
                  }else if(v=="60"){
                    quickData("latih", "60");
                  }
                },
              ),
              onPressed: () {
              })
              : widget.title=="Pilih Untuk Diuji" ?
          IconButton(
              icon: new PopupMenuButton(
                tooltip: "More",
                icon: Icon(Icons.more_vert),
                itemBuilder: (_) => <PopupMenuItem<String>>[
                  new PopupMenuItem<String>(
                      child: const Text('20 Data'), value: '20'),
                ],
                onSelected: (v){
                  if(v=="20"){
                    quickData("uji", "20");
                  }
                },
              ),
              onPressed: () {
              })
              : null,
        ],
      ),
      body: model.isLoading?
        Container(child: Center(child: CircularProgressIndicator(),),)
          : Container(
        child: FutureBuilder<List>(
          future: getRule(model.wordSearch),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    child: Center(
                        child: Text(
                          snapshot.data[i]['kode_rule'],
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                    decoration: BoxDecoration(color: Colors.blue,shape: BoxShape.circle),
                  ),
                  title: Text(snapshot.data[i]['rule']
                      .toString()
                      .replaceAll('.', ' * ')),
                  trailing: Text(snapshot.data[i]['output']),
                  onTap: () {
                    if(widget.title=="Pembentukkan Rule"){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DetailRuleFuzzy(
                                    kode_rule: snapshot.data[i]
                                    ['kode_rule'],
                                  )));
                    }else{
                      selected(snapshot.data[i]['kode_rule']);
                    }

                  },
                );
              },
            )
                : Center(child: CircularProgressIndicator());
          },
        ),
      )
      ,
    );
  }
}
