import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/model/modeladmin.dart';
import 'package:gingivitis/activity/admin/pembentukan_rule.dart';
import 'package:gingivitis/activity/admin/view_metode.dart';

class LaporanKonsultasi extends StatefulWidget {
  @override
  _LaporanKonsultasiState createState() => _LaporanKonsultasiState();
}

class _LaporanKonsultasiState extends State<LaporanKonsultasi> {

  ModelminKelolaLaporan model = ModelminKelolaLaporan();

  Future<List> getData() async {
    final result = await http.get(link.LinkSource.getLaporanKonsul);
    return json.decode(result.body);
  }

  Future konfirm(String id)async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                "Konfirmasi"),
            content: Text("Apakah anda yakin menghapus data konsultasi?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    hapusData(id);
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
  
  Future hapusData(String id)async{

    final result = await http.post(link.LinkSource.hapusLaporanKonsultasi,body: {
      "id" : id,
    });

    if(result.body=="suk"){
      Fluttertoast.showToast(msg: "Berhasil dihapus", textColor: Colors.white, backgroundColor: Colors.green);
    }else{
      Fluttertoast.showToast(msg: "Terjadi kesalahan, silahkan coba lagi", textColor: Colors.white, backgroundColor: Colors.red);
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
        title: Text("Laporan Konsultasi"),
      ),
      body: Container(
          child: FutureBuilder<List>(
        future: getData(),
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
                      contentPadding: EdgeInsets.all(1),
                      leading: Container(
                        width: 60,
                        height: 60,
                        child: Center(
                            child: Text(
                              "${i+1}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                        decoration: BoxDecoration(
                            color: Colors.blue, shape: BoxShape.circle),
                      ),
                      title: Text(
                        snapshot.data[i]['nama'].toString().toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ViewMetode(id_konsul: snapshot.data[i]['id_konsultasi'].toString(),)));
                      },
                      onLongPress: ()=>konfirm(snapshot.data[i]['id_konsultasi'].toString()),
                      subtitle: Text(
                          "Penyakit : ${snapshot.data[i]['f(y)'] == "1" ? 'Khronis' : snapshot.data[i]['f(y)'] == "0" ? 'Akut' : 'Tidak'}"),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              "${snapshot.data[i]['tgl_konsul'].toString().substring(11, 16)}"),
                          Text(""
                              "${snapshot.data[i]['tgl_konsul'].toString().substring(8, 10)}" +
                              "-" +
                              "${snapshot.data[i]['tgl_konsul'].toString().substring(5, 7)}" +
                              "-" +
                              "${snapshot.data[i]['tgl_konsul'].toString().substring(0, 4)}"),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey, indent: 15),
                  ],
                );
              },
            ),
          )
              : Center(
                  child: Text(
                    "Tidak ada laporan konsultasi",
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                );
        },
      )
//        ListView(
//          children: <Widget>[
//            ListTile(title: Text("USER1"),
//              leading: Container(
//                width: 50,
//                height: 50,
//                child: Center(
//                    child: Text(
//                      "1",
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontWeight: FontWeight.bold),
//                    )),
//                decoration: BoxDecoration(
//                    color: Colors.blue, shape: BoxShape.circle),
//              ),
//              trailing: Text("12 Des 2019"),
//              subtitle: Text("Penyakit : P Akut"),
//            ),
//            ListTile(title: Text("USER1"),
//              leading: Container(
//                width: 50,
//                height: 50,
//                child: Center(
//                    child: Text(
//                      "2",
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontWeight: FontWeight.bold),
//                    )),
//                decoration: BoxDecoration(
//                    color: Colors.blue, shape: BoxShape.circle),
//              ),
//              trailing: Text("12 Des 2019"),
//              subtitle: Text("Penyakit : P Khronis"),
//            ),
//            ListTile(title: Text("USER3"),
//              leading: Container(
//                width: 50,
//                height: 50,
//                child: Center(
//                    child: Text(
//                      "3",
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontWeight: FontWeight.bold),
//                    )),
//                decoration: BoxDecoration(
//                    color: Colors.blue, shape: BoxShape.circle),
//              ),
//              trailing: Text("12 Des 2019"),
//              subtitle: Text("Penyakit : P Akut"),
//            ),
//            ListTile(title: Text("USER4"),
//              leading: Container(
//                width: 50,
//                height: 50,
//                child: Center(
//                    child: Text(
//                      "4",
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontWeight: FontWeight.bold),
//                    )),
//                decoration: BoxDecoration(
//                    color: Colors.blue, shape: BoxShape.circle),
//              ),
//              trailing: Text("12 Des 2019"),
//              subtitle: Text("Penyakit : Tidak"),
//            ),
//          ],
//        ),
          ),
    );
  }
}
