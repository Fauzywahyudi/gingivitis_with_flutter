import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/model/modeladmin.dart';
import 'package:gingivitis/activity/admin/informasi/detail_pencegahan.dart';

class KelolaPencegahan extends StatefulWidget {
  @override
  _KelolaPencegahanState createState() => _KelolaPencegahanState();
}

class _KelolaPencegahanState extends State<KelolaPencegahan> {

  ModelminPencegahan model = new ModelminPencegahan();

  Future<List> getData() async {
    final result = await http.get(link.LinkSource.getPencegahan);
//    model.dataGejala = json.decode(result.body);
    return json.decode(result.body);
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

  Future<int> konfirm(String id, String nama)async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                "Konfirmasi"),
            content: Text("Apakah anda yakin menghapus $nama?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    hapus(id,nama);
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

  Future<int> hapus(String id, String nama)async{
    final result = await http.post(link.LinkSource.hapusPencegahan, body: {
      "id": id,
    });
    String msg = result.body;
    if(msg=="suk"){
      Fluttertoast.showToast(msg: '$nama dihapus',textColor: Colors.white,backgroundColor: Colors.green);
    }else{
      Fluttertoast.showToast(msg: 'gagal menghapus',textColor: Colors.white,backgroundColor: Colors.red);
    }
    handleRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pencegahan"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>Navigator.pushNamed(context, '/tambahpencegahan'),
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
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.blue),
                            child: Center(
                                child: Text(
                                  ("${i+1}").toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          title: Text(
                            snapshot.data[i]['nama_pencegahan'],
                            style: TextStyle(fontSize: 20),
                          ),
                          contentPadding: EdgeInsets.all(1),
                          onLongPress: (){

                            konfirm(snapshot.data[i]['id_pencegahan'].toString(), snapshot.data[i]['nama_pencegahan']);
                          },
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DetailPencegahan(
                                        kode: snapshot.data[i]
                                        ['id_pencegahan'],
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
