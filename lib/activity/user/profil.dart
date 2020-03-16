import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/sqlite/DBHelper.dart';
import 'package:http/http.dart' as http;
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:gingivitis/model/model.dart';

class ProfilUser extends StatefulWidget {
  @override
  _ProfilUserState createState() => _ProfilUserState();
}

class _ProfilUserState extends State<ProfilUser> {
  ModelProfilUser model = new ModelProfilUser();

  TextStyle styleBiodata = new TextStyle(
      color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold);

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
      model.jekel = model.dataUser[0]['jk'];
      model.tmp_lahir = model.dataUser[0]['tmp_lahir'];
      model.tgl_lahir = model.dataUser[0]['tgl_lahir'];
      model.alamat = model.dataUser[0]['alamat'];
      model.nohp = model.dataUser[0]['nohp'];
      model.tgl_daftar = model.dataUser[0]['tgl_daftar'];
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

  @override
  void initState() {
    getDataUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    model.fullWidth = MediaQuery.of(context).size.width;
    model.fullHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () => Navigator.pushNamed(context, '/editprofil'),
      ),
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
                title: Text(model.nama.toUpperCase()),
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
                            margin: EdgeInsets.all(10),
                            child: Image.asset(
                                "${model.jk == 1 ? 'assets/images/man.png' : model.jk == 0 ? 'assets/images/girl.png' : null}")),
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
          child: model.tgl_daftar==""||model.tgl_daftar==null?
              Center(child: CircularProgressIndicator(),)
              : ListView(

            children: <Widget>[
              ListTile(
                title: Text(model.nama.toUpperCase(),),
                leading: Icon(Icons.person),
                subtitle: Text('Nama Lengkap'),
              ),
              ListTile(
                title: Text(model.jekel.toUpperCase(),),
                leading: Icon(Icons.wc),
                subtitle: Text('Jenis Kelamin'),
              ),
              ListTile(
                title: Text("${model.tmp_lahir==null||model.tmp_lahir==""? "-": model.tmp_lahir.toUpperCase()}"),
                leading: Icon(Icons.add_location),
                subtitle: Text('Tempat Lahir'),
              ),
              ListTile(
                title: Text("${model.tgl_lahir==null|| model.tgl_lahir==""? "-":model.tgl_lahir}"),
                leading: Icon(Icons.date_range),
                subtitle: Text('Tanggal Lahir'),
              ),
              ListTile(
                title: Text("${model.alamat==null||model.alamat=="" ? "-" : model.alamat.toUpperCase()}"),
                leading: Icon(Icons.location_on),
                subtitle: Text('Alamat'),
              ),
              ListTile(
                title: Text("${model.nohp==""? "-": model.nohp}"),
                leading: Icon(Icons.smartphone),
                subtitle: Text('No HP'),
              ),
              ListTile(
                title: Text(model.tgl_daftar),
                leading: Icon(Icons.date_range),
                subtitle: Text('Tanggal Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
