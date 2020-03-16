import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/model/modeladmin.dart';
import 'package:gingivitis/activity/admin/gejala/detail_gejala.dart';

class KelolaGejala extends StatefulWidget {
  @override
  _KelolaGejalaState createState() => _KelolaGejalaState();
}

class _KelolaGejalaState extends State<KelolaGejala> {
  ModelminKelolaGejala model = new ModelminKelolaGejala();

  Future<List> getGejala() async {
    final result = await http.get(link.LinkSource.getGejala);
    model.dataGejala = json.decode(result.body);
    return json.decode(result.body);
  }

  Future konfirm(String kode_gejala)async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                "Konfirmasi"),
            content: Text("Apakah anda yakin menghapus $kode_gejala?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    hapusGejala(kode_gejala);
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

  Future<int> hapusGejala(String kode_gejala)async{
    final result = await http.post(link.LinkSource.hapusGejala, body: {
      "kode_gejala": kode_gejala,
    });
    String msg = result.body;
    if(msg=="1"){
      Fluttertoast.showToast(msg: '$kode_gejala dihapus',textColor: Colors.white,backgroundColor: Colors.green);
    }else{
      Fluttertoast.showToast(msg: 'gagal menghapus',textColor: Colors.white,backgroundColor: Colors.red);
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
  void initState() {
//    model.scrollController.addListener(_scrollListener);
//    getDataAdmin();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Gejala'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,),
        onPressed: ()=>Navigator.pushNamed(context, '/tambahgejala'),
        tooltip: 'Tambah Gejala',
      ),
      body: Container(
          child: FutureBuilder<List>(
        future: getGejala(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? RefreshIndicator(
            onRefresh: handleRefresh,
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            leading: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.blue),
                              child: Center(
                                  child: Text(
                                ("${snapshot.data[i]['kode_gejala']}").toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                            title: Text(
                              snapshot.data[i]['nama_gejala'],
                              style: TextStyle(fontSize: 20),
                            ),
                            contentPadding: EdgeInsets.all(1),
                            onLongPress: (){
                              konfirm(snapshot.data[i]['kode_gejala']);
                            },
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailGejala(
                                          kode_gejala: snapshot.data[i]
                                              ['kode_gejala'],
                                        ))),
                          ),
                          Divider(color: Colors.grey, indent: 15),
                        ],
                      );
                    }),
              )
              : Center(child: CircularProgressIndicator());
        },
      )),
    );
  }
}
