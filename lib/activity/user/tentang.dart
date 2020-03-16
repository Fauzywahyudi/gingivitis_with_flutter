import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/sqlite/DBHelper.dart';
import 'package:http/http.dart' as http;
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:gingivitis/model/model.dart';


class Tentang extends StatefulWidget {
  @override
  _TentangState createState() => _TentangState();
}

class _TentangState extends State<Tentang> {

  ModelTentang model = ModelTentang();

  @override
  Widget build(BuildContext context) {
    model.fullWidth = MediaQuery.of(context).size.width;
    model.fullHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: NestedScrollView(
        controller: model.scrollController,
        headerSliverBuilder: (BuildContext context, bool innerViewIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.blue,
              pinned: true,
              floating: true,
              snap: false,
              expandedHeight: model.fullHeight / 3,
              flexibleSpace: FlexibleSpaceBar(
                title: Text("FAUZY WAHYUDI"),

                centerTitle: true,
                background: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        width: model.fullWidth / 3,
                        height: model.fullWidth / 3,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Container(
                            margin: EdgeInsets.all(12),
                            child: Image.asset(
                                "assets/images/man.png")),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: ListView(
            padding: EdgeInsets.only(top: 0),
            children: <Widget>[
              ListTile(
                title: Text("FAUZY WAHYUDI",),
                leading: Icon(Icons.person),
                subtitle: Text('Nama Lengkap'),
              ),
              ListTile(
                title: Text("16101152630059",),
                leading: Icon(Icons.contact_mail),
                subtitle: Text('No. BP'),
              ),
              ListTile(
                title: Text("Teknik Informatika",),
                leading: Icon(Icons.school),
                subtitle: Text('Jurusan'),
              ),
              ListTile(
                title: Text("Solok"),
                leading: Icon(Icons.add_location),
                subtitle: Text('Tempat Lahir'),
              ),
              ListTile(
                title: Text("5 Juni 1997"),
                leading: Icon(Icons.date_range),
                subtitle: Text('Tanggal Lahir'),
              ),
              ListTile(
                title: Text("Dalam Gadung, Lubuk Begalung, Padang"),
                leading: Icon(Icons.location_on),
                subtitle: Text('Alamat'),
              ),
              ListTile(
                title: Text("082288229856"),
                leading: Icon(Icons.smartphone),
                subtitle: Text('No. HP'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

