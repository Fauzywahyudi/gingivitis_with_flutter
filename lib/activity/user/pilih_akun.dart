import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/sqlite/DBHelper.dart';
import 'package:http/http.dart' as http;
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:gingivitis/model/model.dart';
import 'package:gingivitis/activity/user/login_user.dart';

class PilihAkun extends StatefulWidget {
  @override
  _PilihAkunState createState() => _PilihAkunState();
}

class _PilihAkunState extends State<PilihAkun> {
  ModelPilihAkun model = new ModelPilihAkun();

  Future<List> getData() async {
    var db = new DBHelper();
    List<Map> list = await db.getAkun();
    return list;
  }

  Future<int> delAkun(int id)async {
    var db = new DBHelper();
    int res = await db.delAkun(id);

    if(res==1){
      print('sukses del');
      Fluttertoast.showToast(msg: "Akun berhasil dihapus",backgroundColor: Colors.green,textColor: Colors.white);
    }
    setState(() {
      if (model.reloadData == 0) {
        model.reloadData = 1;
      } else if (model.reloadData == 1) {
        model.reloadData = 0;
      }
    });
    return res;
  }

  Future<int> delPass(int id)async {
    var db = new DBHelper();
    int res = await db.delPass(id);
    print("delpass code : $res");
    if(res==1){
      print('sukses del PASS');
      Fluttertoast.showToast(msg: "Password berhasil dihapus",backgroundColor: Colors.green,textColor: Colors.white);
    }
    setState(() {
      if (model.reloadData == 0) {
        model.reloadData = 1;
      } else if (model.reloadData == 1) {
        model.reloadData = 0;
      }
    });
    return res;
  }

  Future<int> login(int id, String username)async{
    var db = new DBHelper();
    List result = await db.ceklogin(id);
    String pass = result[0]['password'];
    if(pass.isEmpty){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>LoginUser(username: username,)));
    }else{
      int res = await db.login(id);
      print('login code : $res');
      if(res==1){
        print('sukseslogin');
        Fluttertoast.showToast(msg: "Login Berhasil",backgroundColor: Colors.green,textColor: Colors.white);
        Navigator.pushReplacementNamed(context, '/home');
      }
    }

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
      body: Container(
        color: Colors.blue,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 50),
                    height: 200,
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        "Pilih Akun User",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Container(
                      height: 60,
                      color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pushReplacementNamed(
                                  context, '/loginadmin'))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                          height: MediaQuery.of(context).size.height/3,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10),
                          child: FutureBuilder<List>(
                            future: model.reloadData==0? getData() : getData(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) print(snapshot.error);
                              return snapshot.hasData
                                  ? RefreshIndicator(
                                onRefresh: handleRefresh,
                                child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, i) {
                                    return
                                      Container(
                                        margin:
                                        EdgeInsets.only(top: 3, bottom: 3),
                                        color: Colors.blue,
                                        child: ListTile(
                                          leading: Icon(Icons.person,color: Colors.white,),
                                          onTap: (){
                                            login(snapshot.data[i]['id'],snapshot.data[i]['username']);
                                          },
                                          title: Text(
                                            snapshot.data[i]['nama']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          trailing:
                                          IconButton(
                                              color: Colors.white,
                                              icon: new PopupMenuButton(
                                                tooltip: "More",
                                                icon: Icon(Icons.more_vert),
                                                itemBuilder: (_) => <PopupMenuItem<String>>[
                                                  new PopupMenuItem<String>(
                                                      child: const Text('Hapus Akun'), value: 'delakun'),
                                                  new PopupMenuItem<String>(
                                                      child: const Text('Hapus Password'), value: 'delpass'),
                                                ],
                                                onSelected: (v){
                                                  if(v=="delakun"){
                                                    delAkun(snapshot.data[i]['id']);
                                                  }else if(v=="delpass"){
                                                    delPass(snapshot.data[i]['id']);
                                                  }
                                                },
                                              ),
                                              onPressed: () {
                                              }),
                                        ),
                                      );
                                  },
                                ),
                              )
                                  : Center(
                                      child: Text("Belum Ada User yang Terdaftar",style: TextStyle(color: Colors.grey,fontSize: 20),),
                                    );
                            },
                          )),
                      Container(
                        margin: const EdgeInsets.all(20.0),
                        child: RaisedButton(
                          onPressed: ()=>Navigator.pushReplacementNamed(context, '/loginuser'),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Login ke Akun lainnya",
                                style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                          ),
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
