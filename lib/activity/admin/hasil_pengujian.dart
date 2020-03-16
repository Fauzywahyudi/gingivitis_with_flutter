import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/model/modeladmin.dart';
import 'package:gingivitis/activity/admin/pembentukan_rule.dart';

class HasilPengujian extends StatefulWidget {
  @override
  _HasilPengujianState createState() => _HasilPengujianState();
}

class _HasilPengujianState extends State<HasilPengujian> {

  ModelminHasilPengujian model = new ModelminHasilPengujian();

  Future<List> getProses() async {
    final result = await http.get(link.LinkSource.showProsesPengujian);
    return json.decode(result.body);
  }

  Future<List> getData()async{

    final res1 = await http.post(link.LinkSource.hasilPengujian, body: {
      "type": "0",
    });
    setState(() {
      model.jumlahData = double.parse(res1.body);
    });
    final res2 = await http.post(link.LinkSource.hasilPengujian, body: {
      "type": "1",
    });
    setState(() {
      model.jumlahakurat = double.parse(res2.body);
      model.presentasiAkurat = (model.jumlahakurat/model.jumlahData)*100;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.title),
        actions: <Widget>[
          model.showProses
              ? IconButton(
            onPressed: () {
              setState(() {
                model.showProses = false;
                model.title = "Hasil Pengujian";
              });
            },
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
          )
              : Container()
        ],
      ),
      body: model.showProses
          ? show()
          : Container(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Jumlah data uji : " +model.jumlahData.toString(),
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Data akurat : "+model.jumlahakurat.toString(),
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Presentasi Akurasi : "+ model.presentasiAkurat.toString()+"%" ,
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Center(
              child: RaisedButton(
                child: Container(
                  child: Text(
                    "Lihat Proses",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    model.showProses = true;
                    model.title = "Proses Pengujian";
                  });
                },
                color: Colors.blue,
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget show() {
    return Container(
      child: FutureBuilder<List>(
        future: getProses(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData ?
          ListView.builder(itemCount: snapshot.data.length,
            itemBuilder: (context, i){
              return ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  child: Center(
                      child: Text(
                        snapshot.data[i]['id_proses'],
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                  decoration: BoxDecoration(color: Colors.blue,shape: BoxShape.circle),
                ),
                title: Text(snapshot.data[i]['pola_input']
                    .toString()
                    .replaceAll('.', ' & ')),
                subtitle: Text("t = "+snapshot.data[i]['target']+"\n"+
                    "y = "+snapshot.data[i]['y'] +"\n"+
                    "F(y) = "+snapshot.data[i]['f(y)']),
                trailing: Text(snapshot.data[i]['akurat'],style: TextStyle(color: snapshot.data[i]['akurat']=="1" ? Colors.green : Colors.red,fontWeight: FontWeight.bold),),
                onLongPress: () {
                },
                onTap: () {
                },
              );
            },)
              : CircularProgressIndicator();
        },
      ),
    );
  }
}
