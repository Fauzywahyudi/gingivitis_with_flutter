import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gingivitis/model/modeladmin.dart';
import 'package:gingivitis/sqlite/DBHelper.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/activity/admin/pembentukan_rule.dart';

class HomeAdmin extends StatefulWidget {
  HomeAdmin({this.id});

  final String id;

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  ModelminHome model = new ModelminHome();

  Future<int> getDataAdmin() async {
    final result = await http.post(link.LinkSource.getDataAdmin, body: {
      "id": widget.id,
    });

    model.dataAdmin = json.decode(result.body);
    setState(() {
      model.nama = model.dataAdmin[0]['nama_lengkap'];
    });
    print(model.dataAdmin);
  }

  Future<int> konfirmLogout()async{

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                "Konfirmasi"),
            content: Text("Apakah anda yakin untuk Logout ?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(
                        context, '/splashscreen');
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

  @override
  void initState() {
    getDataAdmin();
//    model.scrollController.addListener(_scrollListener);
//    getDataAdmin();
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
//                actions: <Widget>[
//                  IconButton(
//                      icon: Icon(
//                        Icons.person,
//                        color: Colors.white,
//                      ),
//                      onPressed: () => konfirmLogout())
//                ],
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
                        onTap: (){},
                        child: Container(
                          width: model.fullWidth / 4,
                          height: model.fullWidth / 4,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Container(
                              margin: EdgeInsets.all(10),
                              child: Image.asset('assets/images/admin.png',)),
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
//                    color: Colors.blue,
                  ),
                  width: model.fullWidth / 2 - 40,
                  height: model.fullHeight / 5 +10,
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: InkWell(
                    onTap: () =>
                        Navigator.pushNamed(context, '/laporankonsultasi'),
                    child: Column(
                      children: <Widget>[
                        Center(
                            child: Image.asset('assets/images/pencegahan.png',height: model.fullHeight / 5 -30,)
                        ),
                        Text(
                          "Laporan Konsultasi",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue
                          ),
                          textAlign: TextAlign.center,
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
                  height: model.fullHeight / 5 +10,
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, '/kelolagejala'),
                    child: Column(
                      children: <Widget>[
                        Center(
                            child: Image.asset('assets/images/gejala.png',height: model.fullHeight / 5 -30,)
                        ),
                        Text(
                          "Kelola Gejala",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue
                          ),
                          textAlign: TextAlign.center,
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
//                    color: Colors.blue
                ),
                width: model.fullWidth / 2 - 40,
                height: model.fullHeight / 5 +10,
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => PembentukanRule(
                                title: "Pembentukkan Rule",
                              ))),
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Image.asset('assets/images/rule.png',height: model.fullHeight / 5 -30,)
                      ),
                      Text(
                        "Rule Fuzzy",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
//                    color: Colors.blue
                ),
                width: model.fullWidth / 2 - 40,
                height: model.fullHeight / 5 +10,
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/pelatihan'),
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Image.asset('assets/images/pelatihan.png',height: model.fullHeight / 5 -30,)
                      ),
                      Text(
                        "Pelatihan Perceptron",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue
                        ),
                        textAlign: TextAlign.center,
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
//                    color: Colors.blue
                ),
                width: model.fullWidth / 2 - 40,
                height: model.fullHeight / 5 +10,
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/pengujian'),
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Image.asset('assets/images/pengujian.png',height: model.fullHeight / 5 -30,)
                      ),
                      Text(
                        "Pengujian Perceptron",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
//                    color: Colors.blue
                ),
                width: model.fullWidth / 2 - 40,
                height: model.fullHeight / 5 +10,
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/kelolainformasi'),
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Image.asset('assets/images/pencegahan.png',height: model.fullHeight / 5 -30,)
                      ),
                      Text(
                        "Kelola Informasi",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue
                        ),
                        textAlign: TextAlign.center,
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
//                    color: Colors.blue
                ),
                width: model.fullWidth / 2 - 40,
                height: model.fullHeight / 5 +10,
                margin:
                EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/kelolauser'),
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Image.asset('assets/images/kelolauser.png',height: model.fullHeight / 5 -30,)
                      ),
                      Text(
                        "Kelola User",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
//                    color: Colors.red
                ),
                width: model.fullWidth / 2 - 40,
                height: model.fullHeight / 5 +10,
                margin:
                EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: InkWell(
                  onTap: () => konfirmLogout(),
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(color: Colors.red.withOpacity(0.6),shape: BoxShape.circle,),
                                width: model.fullWidth * 0.25 ,
                                height: model.fullWidth * 0.25,
                              ),
                              Image.asset('assets/images/logout.png',height: model.fullHeight / 5 -30,),
                            ],
                          )
                      ),
                      Text(
                        "Logout",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red
                        ),
                        textAlign: TextAlign.center,
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

//  _scrollListener() {
//    if (isShrink != model.lastStatus) {
//      setState(() {
//        model.lastStatus = isShrink;
//      });
//    }
//  }
//
//  bool get isShrink {
//    return model.scrollController.hasClients &&
//        model.scrollController.offset > (model.fullHeight/5 +15 - kToolbarHeight);
//  }
}
