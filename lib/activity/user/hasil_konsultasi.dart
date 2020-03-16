import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gingivitis/model/model.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/sqlite/DBHelper.dart';
import 'package:gingivitis/activity/user/download_pdf.dart';

class HasilKonsultasi extends StatefulWidget {
  HasilKonsultasi({this.id});
  final String id;
  @override
  _HasilKonsultasiState createState() => _HasilKonsultasiState();
}

class _HasilKonsultasiState extends State<HasilKonsultasi> {

  ModelHasilKonsultasi model = new ModelHasilKonsultasi();
  Cetak _cetak = Cetak();

  Future<int> getData()async{
    final result = await http.post(link.LinkSource.getDataKonsultasi, body: {
      "id": widget.id,
    });
//    print(result.body);
    setState(() {
      model.data = json.decode(result.body);
      model.fy = int.parse(model.data[0]['f(y)']);
    });
    var db = new DBHelper();
    List<Map> list = await db.getData();
    setState(() {
      model.nama  = list[0]['nama'];
    });
  }

  Future<List> getSolusi()async{
    final result = await http.get(link.LinkSource.getSolusi);
    return json.decode(result.body);
  }

  Future<List> getPencegahan()async{
    final result = await http.get(link.LinkSource.getPencegahan);
//    print(result.body);
    return json.decode(result.body);
  }

  Future<bool>willPop()async{
    bool res = false;
    return res;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Hasil Konsultasi"),
          leading: IconButton(icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.pushReplacementNamed(context, '/home');
              }),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.report_problem),
                onPressed: (){
                  Navigator.pushNamed(context, '/lihatproses');
            }),
//            IconButton(icon: Icon(Icons.exit_to_app),
//            onPressed: (){
//              Navigator.pushReplacementNamed(context, '/home');
//            }),

          ],
        ),
//        floatingActionButton: FloatingActionButton(
//          child: Icon(Icons.insert_drive_file),
//          onPressed: (){
//            _cetak.cetak();
//          },
//        ),
        body: model.nama==""||model.nama==null?
            Center(child: CircularProgressIndicator(),)
            :
        Container(
          padding: EdgeInsets.all(5),
          child:
          Stack(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:  EdgeInsets.all(15.0),
                      child: Text("${model.nama.toUpperCase()}. Anda ${model.fy==-1 ? "Tidak" : ""} terdiagnosa penyakit : Gingivitis ${model.fy==0? "Akut" : model.fy==1 ? "Khronis" : ""} \n"
                        ,textAlign: TextAlign.justify
                        ,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    ),

                  ],
                ),
              ),
              model.fy ==-1 ?
              Container(
                margin: EdgeInsets.only(top: 60),
                child: FutureBuilder<List>(
                  future: getPencegahan(),
                  builder: (context, snapshot){
                    if(snapshot.hasError)print(snapshot.error);
                    return snapshot.hasData ?
                    ListView.builder(itemCount: snapshot.data.length,
                      itemBuilder: (context, i){
                        return Container(
                          padding: EdgeInsets.only(top: 10,right: 10,left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Pencegahan ${i+1} : "+snapshot.data[i]['nama_pencegahan'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                              Text(snapshot.data[i]['ket'],textAlign: TextAlign.justify,),

                            ],
                          ),
                        );
                      },)
                        : Center(child: CircularProgressIndicator());
                  },
                ),
              )
                  : Container(
                margin: EdgeInsets.only(top: 60),
                child: FutureBuilder<List>(
                  future: getSolusi(),
                  builder: (context, snapshot){
                    if(snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData ?
                    ListView.builder(
                      itemCount:  snapshot.data.length,
                      itemBuilder: (context, i){
                        return Container(
                          padding: EdgeInsets.only(top: 10,right: 10,left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Solusi ${i+1} : "+snapshot.data[i]['nama_solusi'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                              Text(snapshot.data[i]['ket'],textAlign: TextAlign.justify,),

                            ],
                          ),
                        );
                      },
                    ) :
                    Center(child: CircularProgressIndicator(),);
                  },
                ),
              ),

            ],
          ),
//        Center(
//          child: CircularProgressIndicator(),
//        ),
        ),
      ),
    );
  }
}
