import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gingivitis/model/model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;

class Pencegahan extends StatefulWidget {
  @override
  _PencegahanState createState() => _PencegahanState();
}

class _PencegahanState extends State<Pencegahan> {
  Future<List> getData() async {
    final result = await http.get(link.LinkSource.getPencegahan);
//    model.dataGejala = json.decode(result.body);
    return json.decode(result.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pencegahan"),
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
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/infopenyakit');
                },
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
                selected: true,
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
      body: Container(
        child: FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                 "${i+1}. " +
                                    snapshot.data[i]['nama_pencegahan'],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(snapshot.data[i]['ket'],textAlign: TextAlign.justify,),
                            )
                          ],
                        ),
                      );
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}
