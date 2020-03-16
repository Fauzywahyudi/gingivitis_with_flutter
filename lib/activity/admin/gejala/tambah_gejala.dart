import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/model/modeladmin.dart';

class TambahGejala extends StatefulWidget {
  @override
  _TambahGejalaState createState() => _TambahGejalaState();
}

class _TambahGejalaState extends State<TambahGejala> {
  ModelminTambahGejala model = new ModelminTambahGejala();

  Future<int> konfirm(String gejala){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                "Konfirmasi"),
            content: Text("Apakah anda yakin menambahkan $gejala?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    tambah(gejala);
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

  Future<int> tambah(String gejala)async{
    final result = await http.post(link.LinkSource.tambahGejala, body: {
      "gejala": gejala,
    });
    String msg = result.body;

    if(msg=="1"){
      Fluttertoast.showToast(msg: "Berhasil ditambahkan",backgroundColor: Colors.green,textColor: Colors.white);
    }else if(msg=="0"){
      Fluttertoast.showToast(msg: "Gagal menambahkan",backgroundColor: Colors.red,textColor: Colors.white);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Gejala"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
            tooltip: "Simpan",
            onPressed: ()=>konfirm(model.edc_gejala.text),
          )
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: model.edc_gejala,
                  focusNode: model.foc_gejala,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      labelText: "Nama Gejala",
                      hintStyle: TextStyle(color: Colors.white60)),
                  onChanged: (v) {
                    setState(() {});
                  },
                ),
              ),
//              Padding(
//                padding: const EdgeInsets.all(12.0),
//                child: Center(
//                    child: Text(
//                  "Himpunan",
//                  style: TextStyle(fontSize: 20),
//                )),
//              ),
//              Container(
//                height: MediaQuery.of(context).size.height / 3,
//                child: Center(child: Text("Himpunan Kosong")),
//              ),
//              Container(
//                margin: EdgeInsets.only(top: 50),
//                child: Center(
//                  child: RaisedButton(
//                    child: Text(
//                      "Tambah \nHimpunan",
//                      textAlign: TextAlign.center,
//                      style: TextStyle(color: Colors.white),
//                    ),
//                    onPressed: () {},
//                    color: Colors.blue,
//                  ),
//                ),
//              ),
            ],
          ),
        ),
      ),
    );
  }
}
