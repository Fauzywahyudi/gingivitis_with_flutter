import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/model/modeladmin.dart';
import 'package:gingivitis/activity/admin/pembentukan_rule.dart';

class PelatihanPerceptron extends StatefulWidget {
  @override
  _PelatihanPerceptronState createState() => _PelatihanPerceptronState();
}

class _PelatihanPerceptronState extends State<PelatihanPerceptron> {

  ModelminPelatihan model = new ModelminPelatihan();
  ModelminPembentukanRule model2 = new ModelminPembentukanRule();

  Future<List> getDataPelatihan(String kata)async{
      if (model.isSearch == false) {
        final result = await http.get(link.LinkSource.getDataPelatihan);
        model.data = json.decode(result.body);
        setState(() {
          model.jumlahData = model.data.length;
        });
//        print(model.jumlahData.toString());
        return json.decode(result.body);
      } else {
        final result = await http.post(link.LinkSource.searchDataRulePelatihan, body: {
          "kata": kata,
        });
        return json.decode(result.body);
      }
  }

  Future<List> prosesPelatihan()async{
    final result = await http.get(link.LinkSource.prosesPelatihan);
    Navigator.pushReplacementNamed(context, '/hasilpelatihan');
    setState(() {
      model.loading =false;
    });
    print(result.body);
  }

  Future<List> konfirmReset()async{
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                "Konfirmasi"),
            content: Text("Apakah anda yakin menghapus semua data pelatihan?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    resetData();
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

  Future<int> resetData()async{
    final result = await http.get(link.LinkSource.resetDataPelatihan);
    String msg = result.body;
    if(msg=="1"){
      Fluttertoast.showToast(msg: "Data berhasil diReset",backgroundColor: Colors.green,textColor: Colors.white);
      setState(() {
        model.jumlahData=0;
      });
    }else if(msg=="0"){
      Fluttertoast.showToast(msg: "Data gagal diReset",backgroundColor: Colors.red,textColor: Colors.white);
    }else{
      Fluttertoast.showToast(msg: "Error tidak diketahui",backgroundColor: Colors.grey,textColor: Colors.white);
    }
    handleRefresh();
  }


  Future<Null> handleRefresh() async {
    Completer<Null> completer = new Completer<Null>();
    new Future.delayed(new Duration(milliseconds: 500)).then((_) {
      completer.complete();
      setState(() {
        if (model.reloadData == 0) {
          model.reloadData = 1;
        } else if (model.reloadData == 1) {
          model.reloadData = 0;
        }
      });
    });
    return completer.future;
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
//          autofocus: model.isSearch,
        )
            :Text("Data Pelatihan"),
        actions: <Widget>[


          model.isSearch ?
              IconButton(
                icon: Icon(Icons.close),
                onPressed: (){
                  setState(() {
                    model.isSearch=false;
                    model.edc_search.text="";
                  });
                },
              )
              :
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              setState(() {
                model.isSearch=true;
              });
            },
          ),
          IconButton(
              icon: new PopupMenuButton(
                tooltip: "More",
                icon: Icon(Icons.more_vert),
                itemBuilder: (_) => <PopupMenuItem<String>>[
                  new PopupMenuItem<String>(
                      child: const Text('Reset Data'), value: 'reset'),
                  new PopupMenuItem<String>(
                      child: const Text('Buka Rule'), value: 'rule'),
                  new PopupMenuItem<String>(
                      child: const Text('Hasil Pelatihan'), value: 'hasil'),
                ],
                onSelected: (v){
                  if(v=="reset"){
                    konfirmReset();
                  }else if(v=="rule"){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>PembentukanRule(title: "Pilih Untuk Dilatih",)));
                  }else if(v=="hasil"){
                    Navigator.pushReplacementNamed(context, '/hasilpelatihan');
                  }
                },
              ),
              onPressed: () {
              }),
        ],
      ),
      floatingActionButton:
      model.jumlahData==0?
      FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "Pilih Rule",
        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>PembentukanRule(title: "Pilih Untuk Dilatih",))),
      )
          : FloatingActionButton(
        child: Icon(Icons.play_arrow),
        tooltip: "Jalankan Pelatihan",
        onPressed: (){
          setState(() {
            model.loading = true;
          });
          prosesPelatihan();
          print("latih");

        },
      ),
      body: model.loading ?
        Center(child: CircularProgressIndicator())
          :
          data(),
    );
  }

  Widget data(){
    return Container(
      child: FutureBuilder<List>(
        future: model.reloadData==0? getDataPelatihan(model.wordSearch) : getDataPelatihan(model.wordSearch),
        builder: (context, snapshot){
          if(snapshot.hasError)print(snapshot.error);
          return snapshot.hasData ?
          RefreshIndicator(
            onRefresh: handleRefresh,
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context,i){
                return
                  ListTile(
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
                    trailing: Text(snapshot.data[i]['target']),
                    onLongPress: () {
                    },
                    onTap: () {
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (BuildContext context) =>
//                                      DetailRuleFuzzy(
//                                        kode_rule: snapshot.data[i]
//                                        ['kode_rule'],
//                                      )));
                    },
                  );
              },
            ),
          ) :
          Center(
            child: Text(
              "${model.isSearch? "Tidak dapat menemukan data": "Anda belum menambahkan data untuk dilatih"}",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey,fontSize: 25),
            ),
          );
        },
      ),
    );
  }
}
