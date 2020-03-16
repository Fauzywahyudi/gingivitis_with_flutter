import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/model/modeladmin.dart';
import 'package:gingivitis/activity/admin/detail_rule_fuzzy.dart';

class KelolaInformasi extends StatefulWidget {
  @override
  _KelolaInformasiState createState() => _KelolaInformasiState();
}

class _KelolaInformasiState extends State<KelolaInformasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kelola Informasi"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.beach_access),
              title: Text("Pencegahan",style: TextStyle(fontSize: 20,),),
              onTap: ()=>Navigator.pushNamed(context, '/kelolapencegahan'),
            ),
            Divider(color: Colors.grey,indent: 15,),
            ListTile(
              leading: Icon(Icons.check_box),
              title: Text("Solusi",style: TextStyle(fontSize: 20,),),
              onTap: ()=>Navigator.pushNamed(context, '/kelolasolusi'),
            ),
            Divider(color: Colors.grey,indent: 15,),
          ],
        ),
      ),
    );
  }
}
