import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;

class InfoGejala extends StatefulWidget {
  @override
  _InfoGejalaState createState() => _InfoGejalaState();
}

class _InfoGejalaState extends State<InfoGejala> {
  Future<List> getData() async {
    final result = await http.get(link.LinkSource.getGejala);
    return json.decode(result.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Info Gejala"),
      ),
      endDrawer: Drawer(
        child: Container(
          child: ListView(
            children: <Widget>[
              Container(
                height: 200,
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Informasi Penyakit Gingivitis',textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "Info Penyakit",
                  style: TextStyle(fontSize: 20),
                ),
                leading: Icon(
                  Icons.info,
                  size: 30,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/infopenyakit');
                },
              ),
              ListTile(
                title: Text(
                  "Info Gejala",
                  style: TextStyle(fontSize: 20),
                ),
                leading: Icon(
                  Icons.info,
                  size: 30,
                ),
                selected: true,
              ),
              ListTile(
                title: Text(
                  "Info Pencegahan",
                  style: TextStyle(fontSize: 20),
                ),
                leading: Icon(
                  Icons.info,
                  size: 30,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/pencegahan');
                },
              ),
              ListTile(
                title: Text(
                  "Info Solusi",
                  style: TextStyle(fontSize: 20),
                ),
                leading: Icon(
                  Icons.info,
                  size: 30,
                ),
                onTap: () {
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
                      return ListTile(
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
                          snapshot.data[i]['nama_gejala'],
                          style: TextStyle(
                            fontSize: 20,
                          ),
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
