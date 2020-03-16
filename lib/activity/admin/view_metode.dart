import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/model/modeladmin.dart';

class ViewMetode extends StatefulWidget {
  ViewMetode({this.id_konsul});
  final String id_konsul;
  @override
  _ViewMetodeState createState() => _ViewMetodeState();
}

class _ViewMetodeState extends State<ViewMetode> with TickerProviderStateMixin{

  ModelminMetode model = ModelminMetode();

  Future<List> getData()async{

    print("id konsul : ${widget.id_konsul}");


    final res = await http.get(link.LinkSource.getVariabel);
    setState(() {
      model.variabel=json.decode(res.body);
      model.bobot = model.variabel[0]['bobot_baru'].toString().split(";");
      model.bias = double.parse(model.variabel[0]['bias_baru']);
      print(model.variabel);
    });

    final result = await http.post(link.LinkSource.getDetailKonsultasi, body: {
      "id": widget.id_konsul,
    });
    setState(() {
      model.dataKonsul=json.decode(result.body);
      print(model.dataKonsul.toString());
//      model.showJawaban=model.dataKonsul[0]['pola_gejala'].toString().split(";");
      model.data = model.dataKonsul[0]['pola_gejala'].toString().split(";");

    });

    final result1 = await http.post(link.LinkSource.lihatProsesMetode, body: {
      "id": widget.id_konsul,
    });
    setState(() {
      model.lihatHitungan = result1.body;
    });

    final resFuzzy = await http.get(link.LinkSource.prosesFuzzy);
    setState(() {
      String data = resFuzzy.body.replaceAll("]**[", ",");

      model.dataRuleFuzzy = json.decode(data);
      print(model.dataRuleFuzzy.toString());
    });
  }
  Future<List>getGejala()async{
    final res = await http.get(link.LinkSource.getGejala);

    return json.decode(res.body);
  }

  @override
  void initState() {
    model.tabController = new TabController(length: 2, vsync: this);
    getData();
//    model.tabController.addListener(_listener);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: model.scrollController,
        headerSliverBuilder: (BuildContext context, bool innerViewIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text("View Perhitungan Metode"),
              pinned: true,
              floating: true,
              snap: true,
              elevation: 2,
//              title:
//              model.isSearch ?TextField(
//                controller: model.searchTransaksi,
//                autofocus: true,
//                style: TextStyle(color: colorPrimary),
//                onChanged: (v){
//                  if (model.tabController.index == 0) {
//                    setState(() {
//                      model.wordSearch1 = v;
//                    });
//                  }
//                  if (model.tabController.index == 1) {
//                    setState(() {
//                      model.wordSearch2 = v;
//                    });
//                  }
//                },
//                decoration: new InputDecoration(
//                    border: InputBorder.none,
//                    hintText: "Search...",
//                    hintStyle: new TextStyle(color: colorPrimary)),
//              ):
//              Text(
//                "${model.index == 0 ? "Hutang " : "Piutang "}" + "${model.index == 0 ? model.formatter.format(model.totHutang) : model.formatter.format(model.totPiutang)}",
//                style: TextStyle(
//                  fontWeight: FontWeight.bold,
//                  fontSize: 20.0,
//                ),
//              ),

              forceElevated: innerViewIsScrolled,
              bottom: TabBar(
                controller: model.tabController,
                indicatorWeight: 5,
                onTap: (v)=>setState(() {
                  model.scrollController.position.setPixels(0);
                }),
                tabs: <Widget>[
                  Tab(
                    text: "Perceptron",
                  ),
                  Tab(
                    text: "Fuzzy",
                  ),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: model.tabController,
          children: <Widget>[
            Container(
              child: perceptron(),
            ),
            Container(
              child: fuzzy(),
            ),
          ],
        ),

      ),
    );
  }

  perceptron(){
    return Container(
      child: ListView(
        padding: EdgeInsets.only(top: 0),
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

  fuzzy(){
    return Container(
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: <Widget>[
          ListTile(
            title: Text("Fuzzifikasi",style: TextStyle(fontWeight: FontWeight.bold),),
            leading: model.showFuzzifikasi ? Icon(Icons.arrow_drop_down) :Icon(Icons.arrow_right),
            onTap: (){
              if(model.showFuzzifikasi){
                setState(() {
                  model.showFuzzifikasi=false;
                });
              }else{
                setState(() {
                  model.showFuzzifikasi=true;
                });
              }
            },
          ),
          model.showFuzzifikasi ?
              Container(
                height: 100,
          child: Column(
                children: <Widget>[

                ],
              ),): Container(),

          Divider(),
          ListTile(
            title: Text("Mesin Inferensia",style: TextStyle(fontWeight: FontWeight.bold),),
            leading: Icon(Icons.arrow_right),
          ),
          Divider(),
          ListTile(
            title: Text("Defuzzifikasi",style: TextStyle(fontWeight: FontWeight.bold),),
            leading: Icon(Icons.arrow_right),
          ),
          Divider(),

        ],
      ),
    );
  }
}
