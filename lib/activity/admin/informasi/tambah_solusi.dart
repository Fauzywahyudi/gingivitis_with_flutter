import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/model/modeladmin.dart';

class TambahSolusi extends StatefulWidget {
  @override
  _TambahSolusiState createState() => _TambahSolusiState();
}

class _TambahSolusiState extends State<TambahSolusi> {

  ModelminTambahSolusi model = ModelminTambahSolusi();

  Future<int> tambah()async{

    final result = await http.post(link.LinkSource.addSolusi,body: {
      "nama" : model.edc_nama.text,
      "ket" : model.edc_ket.text,
    });

    if(result.body=="suk"){
      Fluttertoast.showToast(msg: "Berhasil ditambhakan",backgroundColor: Colors.green,textColor: Colors.white);
      Navigator.pop(context);
    }else{
      Fluttertoast.showToast(msg: "Terjadi kesalahan, silahkan ulangi",backgroundColor: Colors.red,textColor: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Solusi"),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.only(top: 0),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: model.edc_nama,
                focusNode: model.foc_nama,
                textInputAction: TextInputAction.next,
                onSubmitted: (v){
                  FocusScope.of(context).requestFocus(model.foc_ket);
                },
                decoration: InputDecoration(
                    labelText: "Nama Solusi",
                    prefixIcon: Icon(Icons.beach_access)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: model.edc_ket,
                focusNode: model.foc_ket,
                maxLines: 5,
                textInputAction: TextInputAction.done,
                onSubmitted: (v){
                  model.foc_ket.unfocus();
                },
                decoration: InputDecoration(
                    labelText: "Keterangan",
                    prefixIcon: Icon(Icons.text_fields)
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20.0),
              child: RaisedButton(
                onPressed: () {
                  if(model.edc_nama.text.isEmpty || model.edc_ket.text.isEmpty){
                    Fluttertoast.showToast(msg: "Mohon lengkapi data",backgroundColor: Colors.red,textColor: Colors.white);
                  }else{
                    tambah();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Simpan",
                      style:
                      TextStyle(color: Colors.white, fontSize: 20)),
                ),
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
