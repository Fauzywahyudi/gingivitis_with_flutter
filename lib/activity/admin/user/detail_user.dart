import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/model/modeladmin.dart';
import 'package:gingivitis/activity/admin/user/edit_user.dart';
import 'package:gingivitis/activity/admin/user/ubah_password_user.dart';

class DetailUser extends StatefulWidget {
  DetailUser({this.id});
  final String id;
  @override
  _DetailUserState createState() => _DetailUserState();
}

class _DetailUserState extends State<DetailUser> {

  ModelminDetailUser model = ModelminDetailUser();

  Future<int> getData()async{
    print("id user adalah :"+widget.id.toString());
    final result = await http.post(link.LinkSource.getDetailUser,body: {
      "id"  : widget.id.toString(),
    });
    setState(() {
      model.data = json.decode(result.body);

      model.id_user = model.data[0]['id_user'];
      model.nama = model.data[0]['nama'];
      model.jk = model.data[0]['jk'];
      model.username = model.data[0]['username'];
      model.password = model.data[0]['password'];
      model.tmp_lahir = model.data[0]['tmp_lahir'];
      model.tgl_lahir = model.data[0]['tgl_lahir'];
      model.alamat = model.data[0]['alamat'];
      model.nohp = model.data[0]['nohp'];
      model.tgl_daftar = model.data[0]['tgl_daftar'];
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    model.fullWidth = MediaQuery.of(context).size.width;
    model.fullHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        tooltip: "Edit User",
        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>EditUser(id: widget.id,) ))
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
                                "${model.jk == "laki-laki" ? 'assets/images/man.png' : 'assets/images/girl.png'}")),
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
                title: Text(model.nama.toUpperCase(),),
                leading: Icon(Icons.person),
                subtitle: Text('Nama Lengkap'),
              ),
              ListTile(
                title: Text(model.username,),
                leading: Icon(Icons.contact_mail),
                subtitle: Text('Username'),
              ),
              ListTile(
                title: Text(model.password),
                leading: Icon(Icons.person),
                trailing: IconButton(icon: Icon(Icons.edit),onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>UbahPassword(id: model.id_user,pass: model.password,)));
                },),
                subtitle: Text('Password'),
              ),
              ListTile(
                title: Text(model.jk.toUpperCase(),),
                leading: Icon(Icons.wc),
                subtitle: Text('Jenis Kelamin'),
              ),
              ListTile(
                title: Text("${model.tmp_lahir==null||model.tmp_lahir==""? "-" : model.tmp_lahir.toUpperCase()}"),
                leading: Icon(Icons.add_location),
                subtitle: Text('Tempat Lahir'),
              ),
              ListTile(
                title: Text("${model.tgl_lahir==null||model.tgl_lahir==""? "-" : model.tgl_lahir}"),
                leading: Icon(Icons.date_range),
                subtitle: Text('Tanggal Lahir'),
              ),
              ListTile(
                title: Text("${model.alamat==null||model.alamat==""? "-" : model.alamat.toUpperCase()}"),
                leading: Icon(Icons.location_on),
                subtitle: Text('Alamat'),
              ),
              ListTile(
                title: Text("${model.nohp==null||model.nohp==""? "-" : model.nohp}"),
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
