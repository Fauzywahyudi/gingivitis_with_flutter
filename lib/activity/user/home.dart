import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/model/model.dart';
import 'package:gingivitis/sqlite/DBHelper.dart';
import 'dart:convert';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ModelHome model = new ModelHome();

  Future<List> getDataUser() async {
    var db = new DBHelper();
    List<Map> list = await db.getData();
    setState(() {
      model.nama = list[0]['nama'];
      model.id = list[0]['id'];
    });

    print("id adalah " + model.id.toString());

    final result = await http.post(link.LinkSource.getUser, body: {
      "id": model.id.toString(),
    });

    setState(() {
      model.dataUser = json.decode(result.body);
    });

    print(model.dataUser);

    if (model.dataUser[0]['jk'] == "laki-laki") {
      setState(() {
        model.jk = 1;
      });
    } else {
      setState(() {
        model.jk = 0;
      });
    }
    print(model.nama);
  }

  Future<int> logout(int id) async {
    var db = new DBHelper();
    int res = await db.logout(id);
    print('login code : $res');
    if (res == 1) {
      print('sukseslogin');
      Fluttertoast.showToast(
          msg: "Logout Berhasil",
          backgroundColor: Colors.green,
          textColor: Colors.white);
      Navigator.pushReplacementNamed(context, '/pilihakun');
    }
  }

  Future<int> konfirmLogout() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Konfirmasi"),
            content: Text("Apakah anda yakin untuk Logout ?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    logout(model.id);
                  },
                  child: Text(
                    "Iya",
                    style: TextStyle(color: Colors.green),
                  )),
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Tidak", style: TextStyle(color: Colors.red))),
            ],
          );
        });
  }


  @override
  void initState() {
    getDataUser();

//    model.scrollController.addListener(_scrollListener);
    getDataUser();
    super.initState();
  }

  @override
  void dispose() {
    model.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.fullWidth = MediaQuery.of(context).size.width;
    model.fullHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: NestedScrollView(
          controller: model.scrollController,
          headerSliverBuilder:
              (BuildContext context, bool innerViewIsScrolled) {
            return <Widget>[
              SliverAppBar(
//              actions: <Widget>[
//                    IconButton(
//                      icon: Icon(Icons.lock),color: Colors.white,
//                      onPressed: (){
//                        DateTime tesdate = new DateTime.now();
//                        String date=tesdate.toString().substring(0,19);
//                        print(date.toString());
//                      }
//                    )
//              ],
                backgroundColor: Colors.blue,
                pinned: false,
                floating: true,
                snap: false,
                expandedHeight: model.fullHeight / 5 + 20,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        onTap: () => Navigator.pushNamed(context, '/profil'),
                        child: Container(
                          width: model.fullWidth / 4,
                          height: model.fullWidth / 4,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Container(
                              margin: EdgeInsets.all(10),
                              child: Image.asset(
                                  "${model.jk == 1 ? 'assets/images/man.png' : model.jk == 0 ? 'assets/images/girl.png' : 'assets/images/man.png'}")),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          model.nama.toUpperCase(),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ];
          },
          body: menu()),
    );
  }

  Widget menu() {
    return ListView(
      padding: EdgeInsets.only(top: 0),
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
//                      color: Colors.blue,
                  ),
                  width: model.fullWidth / 2 - 40,
                  height: model.fullHeight / 5,
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: InkWell(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/konsultasi'),
                    child: Column(
                      children: <Widget>[
                        Center(
                            child: Image.asset(
                          'assets/images/konsul.png',
                          height: model.fullHeight / 5 - 30,
                        )),
                        Text(
                          "Konsultasi",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
//                        color: Colors.blue
                  ),
                  width: model.fullWidth / 2 - 40,
                  height: model.fullHeight / 5,
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, '/infopenyakit'),
                    child: Column(
                      children: <Widget>[
                        Center(
                            child: Image.asset(
                          'assets/images/penyakit.png',
                          height: model.fullHeight / 5 - 30,
                        )),
                        Text(
                          "Info Penyakit",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
//                      color: Colors.blue
                ),
                width: model.fullWidth / 2 - 40,
                height: model.fullHeight / 5,
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/infogejala'),
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Image.asset(
                        'assets/images/gejala.png',
                        height: model.fullHeight / 5 - 30,
                      )),
                      Text(
                        "Info Gejala",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
//                      color: Colors.blue
                ),
                width: model.fullWidth / 2 - 40,
                height: model.fullHeight / 5,
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/pencegahan'),
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Image.asset(
                        'assets/images/pencegahan.png',
                        height: model.fullHeight / 5 - 30,
                      )),
                      Text(
                        "Pencegahan",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
//                      color: Colors.blue
                ),
                width: model.fullWidth / 2 - 40,
                height: model.fullHeight / 5,
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/solusi'),
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Image.asset(
                        'assets/images/solusi.png',
                        height: model.fullHeight / 5 - 30,
                      )),
                      Text(
                        "Solusi",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
//                        color: Colors.red
                ),
                width: model.fullWidth / 2 - 40,
                height: model.fullHeight / 5,
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/history'),
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Stack(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/history.png',
                            height: model.fullHeight / 5 - 30,
                          ),
                        ],
                      )),
                      Text(
                        "History Konsultasi",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
//                        color: Colors.red
                ),
                width: model.fullWidth / 2 - 40,
                height: model.fullHeight / 5,
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/tentang'),
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Stack(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/about.png',
                            height: model.fullHeight / 5 - 30,
                          ),
                        ],
                      )),
                      Text(
                        "Tentang",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
//                        color: Colors.red
                ),
                width: model.fullWidth / 2 - 40,
                height: model.fullHeight / 5,
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: InkWell(
                  onTap: () {
                    konfirmLogout();
                  },
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            width: model.fullWidth * 0.25,
                            height: model.fullWidth * 0.25,
                          ),
                          Image.asset(
                            'assets/images/logout.png',
                            height: model.fullHeight / 5 - 30,
                          ),
                        ],
                      )),
                      Text(
                        "Logout",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
