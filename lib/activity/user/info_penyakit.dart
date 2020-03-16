import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gingivitis/model/model.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/sqlite/DBHelper.dart';

class InfoPenyakit extends StatefulWidget {
  @override
  _InfoPenyakitState createState() => _InfoPenyakitState();
}

class _InfoPenyakitState extends State<InfoPenyakit> {

  ModelPenyakit model = new ModelPenyakit();

  Future<List> getData()async{
    final result = await http.get(link.LinkSource.getPenyakit);
    setState(() {
      model.data = json.decode(result.body);
      model.nama = model.data[0]['nama_penyakit'];
      model.ket = model.data[0]['ket'];
    });

    return json.decode(result.body);
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
        title: Text("Info Penyakit"),
      ),
      endDrawer: Drawer(
        child: Container(
          child: ListView(
            children: <Widget>[
              Container(
                height: 200,
                color: Colors.blue,
                child: Center(
                  child: Text('Informasi Penyakit Gingivitis',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
                ),
              ),
              ListTile(
                title: Text("Info Penyakit",style: TextStyle(fontSize: 20),),
                leading: Icon(Icons.info,size: 30,),
                selected: true,
              ),
              ListTile(
                title: Text("Info Gejala",style: TextStyle(fontSize: 20),),
                leading: Icon(Icons.info,size: 30,),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/infogejala');
                },
              ),
              ListTile(
                title: Text("Info Pencegahan",style: TextStyle(fontSize: 20),),
                leading: Icon(Icons.info,size: 30,),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/pencegahan');
                },
              ),
              ListTile(
                title: Text("Info Solusi",style: TextStyle(fontSize: 20),),
                leading: Icon(Icons.info,size: 30,),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/solusi');
                },
              ),
            ],
          ),
        ),
      ),
      body: model.nama==""||model.nama==null?
          Center(child: CircularProgressIndicator(),)
          : Container(
        child: ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(10),
              child: Text(model.nama,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: Text(model.ket,style: TextStyle(),textAlign: TextAlign.justify,),
            ),
          ],
        ),
      ),
    );
  }
}
