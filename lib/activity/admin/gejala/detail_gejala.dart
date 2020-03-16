import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/model/modeladmin.dart';

class DetailGejala extends StatefulWidget {

  DetailGejala({this.kode_gejala});
  final String kode_gejala;

  @override
  _DetailGejalaState createState() => _DetailGejalaState();
}

class _DetailGejalaState extends State<DetailGejala> {

  ModelminDetailGejala model = new ModelminDetailGejala();

  Future<List> getDetailGejala()async{
    final result = await http.post(link.LinkSource.getDetailGejala, body: {
      "kode_gejala": widget.kode_gejala,
    });
    model.dataGejala = json.decode(result.body);
    print(model.dataGejala);
    setState(() {
      model.nama_gejala = model.dataGejala[0]['nama_gejala'];
      model.kode_gejala = model.dataGejala[0]['kode_gejala'];
    });
    return json.decode(result.body);
  }

  Future<List> getHimpunan()async{
    final result = await http.post(link.LinkSource.getHimpunanGejala, body: {
      "kode_gejala": widget.kode_gejala,
    });
    model.dataHimpunan = json.decode(result.body);
//    print(model.dataHimpunan);
    return json.decode(result.body);
  }


  @override
  void initState() {
    getDetailGejala();
    getHimpunan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.kode_gejala),
      ),
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.edit,),
//        tooltip: 'Edit',
//      ),
      body: Stack(
        children: <Widget>[
      Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Nama Gejala :",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(model.nama_gejala,style: TextStyle(fontSize: 20,),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Himpunan Gejala :",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
          Container(
            margin: EdgeInsets.only(top: 130),
            child: FutureBuilder<List>(
              future: getHimpunan(),
              builder: (context, snapshot){
                if(snapshot.hasError)print(snapshot.error);
                return snapshot.hasData ?
                ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i){
                    return ListTile(
                      title: Text(snapshot.data[i]['nama_himpunan'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                      subtitle: Text("min : "+snapshot.data[i]['min_range']+"\n"
                          "max : "+snapshot.data[i]['max_range'],style: TextStyle(fontSize: 16),)
                    );
                  },
                ) :
                Center(
                  child: Text("Anda belum menambahkan \n Himpunan Gejala",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey,fontSize: 20),),
                );
              },
            ),
          ),
        ],
      )
//
    );
  }

}
