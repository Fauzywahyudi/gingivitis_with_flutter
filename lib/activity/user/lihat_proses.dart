import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gingivitis/model/model.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/sqlite/DBHelper.dart';

class LihatProses extends StatefulWidget {
  @override
  _LihatProsesState createState() => _LihatProsesState();
}

class _LihatProsesState extends State<LihatProses> {

  ModelLihatProses model = ModelLihatProses();

  Future<List> getData()async{
    var db = new DBHelper();
    List<Map> list = await db.getData();
    setState(() {
      model.id = list[0]['id'];
    });

    final res = await http.get(link.LinkSource.getVariabel);
    setState(() {
      model.variabel=json.decode(res.body);

//      print(model.variabel.toString());
      model.bobot = model.variabel[0]['bobot_baru'].toString().split(";");
      model.bias = double.parse(model.variabel[0]['bias_baru']);
    });

    final result = await http.post(link.LinkSource.getDataKonsultasi, body: {
      "id": model.id.toString(),
    });
    setState(() {
      model.dataKonsul=json.decode(result.body);
//      print(model.dataKonsul.toString());
//      model.showJawaban=model.dataKonsul[0]['pola_gejala'].toString().split(";");
     model.data = model.dataKonsul[0]['pola_gejala'].toString().split(";");
      
    });

    final result1 = await http.post(link.LinkSource.lihatProses, body: {
      "id": model.id.toString(),
    });
    setState(() {
      model.lihatHitungan = result1.body;
    });
  }

  Future<List>getGejala()async{
    final res = await http.get(link.LinkSource.getGejala);

    return json.decode(res.body);
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
      body: NestedScrollView(
          controller: model.scrollController,
          headerSliverBuilder:
              (BuildContext context, bool innerViewIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.blue,
                pinned: true,
                floating: true,
                snap: false,
                title: Text("Lihat Proses"),
              ),
            ];
          },
          body: body()
      ),
    );
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Lihat Proses"),
//      ),
//      body:
//    );
  }

  body(){
    return Container(
      margin: EdgeInsets.only(top: 0),
      child: ListView(
        children: <Widget>[
          model.showJawaban?
          Container(
            height: MediaQuery.of(context).size.height*0.5,
            child: FutureBuilder<List>(
              future: getGejala(),
              builder: (context, snapshot){
                if(snapshot.hasError)print(snapshot.error);
                return snapshot.hasData?
                ListView.builder(itemCount: snapshot.data.length,
                  itemBuilder: (context,i){
                    return ListTile(
                        title: Text("Gejala : "+snapshot.data[i]['nama_gejala']),
                        subtitle: snapshot.data[i]['ket']=="0"?
                        Text("Jawaban : ${model.data[i]=="1"? "Iya" : model.data[i]=="0"? "Kadang" : "Tidak"} == ${model.data[i]}")
                            :
                        Text("Jawaban : ${model.data[i]=="1"? "Iya" : model.data[i]=="0"? "Mungkin" : "Tidak"} == ${model.data[i]}"),

                        trailing: snapshot.data.length == i+1?
                        IconButton(icon: Icon(Icons.keyboard_arrow_up),
                          onPressed: (){
                            setState(() {
                              model.showJawaban=false;
                            });
                          },)
                            : null

                    );
                  },)
                    : Center(child: CircularProgressIndicator(),);

              },
            ),
          )
              : ListTile(
            title: Text("Jawaban Anda",style: TextStyle(fontWeight: FontWeight.bold),),
            trailing: IconButton(
              icon: Icon(Icons.keyboard_arrow_down),
              onPressed: (){
                setState(() {
                  model.showJawaban=true;
                });
              },
            ),
          ),
          Divider(),
          model.showVariabel ?
          Container(
            height: MediaQuery.of(context).size.height*0.5,
            child: ListView.builder(itemCount: model.bobot.length+1,
              itemBuilder: (context,i){
                return i+1== model.bobot.length+1?
                ListTile(
                  title: Text("Bias  : ${model.bias.toString()}"),
                  trailing: i+1==model.bobot.length+1 ?
                  IconButton(icon: Icon(Icons.keyboard_arrow_up),
                    onPressed: (){
                      setState(() {
                        model.showVariabel=false;
                      });
                    },)
                      : null
                  ,
                )
                    :
                ListTile(
                  title: Text("Bobot X${i+1} : ${model.bobot[i]}"),
                );
              },),
          )
              : ListTile(
            title: Text("Variabel Jaringan",style: TextStyle(fontWeight: FontWeight.bold),),
            trailing: IconButton(
              icon: Icon(Icons.keyboard_arrow_down),
              onPressed: (){
                setState(() {
                  model.showVariabel=true;
                });
              },
            ),
          ),
          Divider(),
          model.showPerhitungan ?
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Text(model.lihatHitungan,textAlign: TextAlign.justify,style: TextStyle(fontSize: 18),),
                    Center(child: IconButton(icon: Icon(Icons.keyboard_arrow_up), onPressed: (){
                      setState(() {
                        model.showPerhitungan=false;
                      });
                    }),)
                  ],
                ),
              )
              : ListTile(
            title: Text("Perhitungan",style: TextStyle(fontWeight: FontWeight.bold),),
            trailing: IconButton(
              icon: Icon(Icons.keyboard_arrow_down),
              onPressed: (){
                setState(() {
                  model.showPerhitungan=true;
                });
              },
            ),
          ),

        ],
      ),
    );
  }
}
