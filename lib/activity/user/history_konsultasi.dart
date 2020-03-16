import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/model/model.dart';
import 'package:gingivitis/sqlite/DBHelper.dart';

class HistoryKonsultasi extends StatefulWidget {
  @override
  _HistoryKonsultasiState createState() => _HistoryKonsultasiState();
}

class _HistoryKonsultasiState extends State<HistoryKonsultasi> {

  ModelHistory model = ModelHistory();

  Future <List> getData()async{


    final result = await http.post(link.LinkSource.historyKonsultasi,body: {
      "id" : model.id,
    });

    return json.decode(result.body);
  }

  Future <int> getId()async{
    var db = new DBHelper();
    List<Map> list = await db.getData();
    setState(() {
      model.id  = list[0]['id'].toString();
    });


  }

  @override
  void initState() {
    getId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History Konsultasi"),
      ),
      body: Container(
        child: FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot){
            if(snapshot.hasError)print(snapshot.error);
            return snapshot.hasData ?
                ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i){
                    return ListTile(
                      leading: Icon(Icons.history),
                      title: Text("${snapshot.data[i]['f(y)']=="1" ? "Gingivitis Khronis" : snapshot.data[i]['f(y)']=="0" ? "Gingivitis Akut" : "Tidak Terdiagnosa"}"),
                      subtitle: Text("${snapshot.data[i]['tgl_konsul']}"),
                    );
                  },
                )
                : Center(child: Text("History Konsultasi Kosong ",style: TextStyle(color: Colors.grey,fontSize: 20),),);
          },
        ),
      ),
    );
  }
}
