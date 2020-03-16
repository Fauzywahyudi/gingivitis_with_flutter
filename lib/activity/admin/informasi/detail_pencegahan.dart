import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/model/modeladmin.dart';
import 'package:gingivitis/activity/admin/informasi/edit_pencegahan.dart';

class DetailPencegahan extends StatefulWidget {
  DetailPencegahan({this.kode});

  final String kode;
  @override
  _DetailPencegahanState createState() => _DetailPencegahanState();
}

class _DetailPencegahanState extends State<DetailPencegahan> {

  ModelminPencegahan model = new ModelminPencegahan();

  Future<List> getData() async {
    final result = await http.post(link.LinkSource.getDetailPencegahan, body: {
      "kode": widget.kode,
    });

    setState(() {
      model.data = json.decode(result.body);

      model.nama = model.data[0]['nama_pencegahan'];
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
        title: Text(model.nama),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>EditPencegahan(id: widget.kode,)));
        },
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Text(model.ket,style: TextStyle(fontSize: 17),textAlign: TextAlign.justify,),
      ),
    );
  }
}
