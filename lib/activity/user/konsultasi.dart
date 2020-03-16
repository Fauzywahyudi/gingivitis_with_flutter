import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gingivitis/activity/user/hasil_konsultasi.dart';
import 'package:gingivitis/model/model.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/sqlite/DBHelper.dart';

class Konsultasi extends StatefulWidget {
  @override
  _KonsultasiState createState() => _KonsultasiState();
}

class _KonsultasiState extends State<Konsultasi> {
  ModelKonsultasi model = ModelKonsultasi();

  Future<List> getGejala()async{
    final result = await http.get(link.LinkSource.getGejala);
    model.dataGejala = json.decode(result.body);
    setState(() {
      model.maksGejala = model.dataGejala.length;
    });
    print(model.maksGejala.toString());
    return json.decode(result.body);
  }

  Future<int> insertJawaban(String kode_gejala, int jawaban)async{
    var db = DBHelper();
    int res = await db.jawaban(kode_gejala, jawaban);
  }

  Future<int> resetJawaban()async{
    var db = DBHelper();
    int res = await db.resetJawaban();
  }

  Future<List> getJawaban()async{
    var db = DBHelper();
    List res = await db.getJawaban();
    print("data jawaban :"+res.toString());
  }

  Future<List> getDataUser()async{
    var db = new DBHelper();
    model.dataUser = await db.getData();
    setState(() {
      model.id = model.dataUser[0]['id'];
    });
    print(model.nama);
  }

  Future<int> prosesKonsul()async{
    DateTime tesdate = new DateTime.now();

    String date=tesdate.toString().substring(0,19);

    setState(() {
      model.loading = true;
    });
    var db = DBHelper();
    List data = await db.getJawaban();
    String pola = "";

    for(int i=0; i < data.length; i++){
      if(i==0){
        setState(() {
          pola = data[i]['jawaban'];
        });
      }else{
        setState(() {
          pola = pola+";"+data[i]['jawaban'];
        });
      }
    }

    setState(() {
      model.pola_jawaban = pola;
    });
    print(model.pola_jawaban);

    final result = await http.post(link.LinkSource.prosesKonsultasi, body: {
      "id": model.id.toString(),
      "pola_jawaban": model.pola_jawaban,
      "date" : date,
    });

    print(result.body);

    setState(() {
      model.loading = false;
    });
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext context)=>HasilKonsultasi(id: model.id.toString() ,) ));
  }
  Future<bool>willPop()async{
    bool res = false;

    return res;
  }

  @override
  void initState() {
    getGejala();
    getJawaban();
    getDataUser();
    resetJawaban();

    print('----------------');
    getJawaban();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    model.fullWidth = MediaQuery.of(context).size.width;
    model.fullHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
          body:
          model.loading ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                    margin: EdgeInsets.all(50),
                    width: MediaQuery.of(context).size.width/2,
                    height: MediaQuery.of(context).size.width/2,
                    child: Image.asset(
                      'assets/images/loading.png',
                    )),
              ),
              Center(
                child: Container(
                    margin: EdgeInsets.all(20),
                    child: CircularProgressIndicator()),
              ),
            ],
          ):
          Container(
            width: MediaQuery.of(context).size.width,
            child: model.dataGejala==null||model.dataGejala==""?
                Center(child: CircularProgressIndicator(),)
                : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: model.fullHeight*0.4,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.blue,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: model.fullHeight*0.4,
//                        color: Colors.red,
                          child: Center(
                            child: Text(
                              "Apakah anda merasa \n"+
//                                "Gejala 1?"

                                  "${
                                      model.dataGejala==null? '' : model.dataGejala[model.mulaiGejala]['nama_gejala']
                                  } ?"
                              ,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 27,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 80,
//                        color: Colors.pink,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 15,right: 5),
                                child: IconButton(
                                  onPressed: (){
//                                  getGejala();
                                    print("exit");
                                    Navigator.pushReplacementNamed(context, '/home');
                                  },
                                  icon: Icon(Icons.exit_to_app,color: Colors.white,size: 30,),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          highlightColor: Colors.pink,
                          onTap: (){
                            if(model.select_tidak == true){
                              setState(() {
                                model.select_tidak = false;
                              });
                            }else{
                              setState(() {
                                model.select_tidak = true;
                                model.select_mungkin = false;
                                model.select_iya = false;
                                model.jawaban = -1;
                              });
                            }

                          },
                          child: Container(
                            color: model.select_tidak ? Colors.pink : Colors.blue.withOpacity(0.4),
                            width: MediaQuery.of(context).size.width / 3,
                            height: model.fullHeight*0.15,
                            child: Center(
                              child: Text(
                                "Tidak",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          highlightColor: Colors.pink,
                          onTap: (){
                            if(model.select_mungkin == true){
                              setState(() {
                                model.select_mungkin = false;
                              });
                            }else{
                              setState(() {
                                model.select_tidak = false;
                                model.select_mungkin = true;
                                model.select_iya = false;
                                model.jawaban = 0;
                              });
                            }
                          },
                          child: Container(
                            color: model.select_mungkin ? Colors.pink : Colors.blue.withOpacity(0.6),
                            width: MediaQuery.of(context).size.width / 3,
                            height: model.fullHeight*0.15,
                            child: Center(
                              child: Text(
                                "${model.dataGejala==null ? "" :model.dataGejala[model.mulaiGejala]['ket']=="0" ? "Kadang": "Mungkin"}",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          highlightColor: Colors.pink,
                          onTap: (){
                            if(model.select_iya == true){
                              setState(() {
                                model.select_iya = false;
                              });
                            }else{
                              setState(() {
                                model.select_tidak = false;
                                model.select_mungkin = false;
                                model.select_iya = true;
                                model.jawaban = 1;
                              });
                            }
                          },
                          child: Container(
                            color: model.select_iya ? Colors.pink : Colors.blue.withOpacity(0.8),
                            width: MediaQuery.of(context).size.width / 3,
                            height: model.fullHeight*0.15,
                            child: Center(
                              child: Text(
                                "Iya",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: model.fullHeight*0.4,

                    child: Container(
                      width: model.fullWidth*0.5,
                      height: model.fullWidth*0.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: InkWell(
                          onTap: (){
                            if(model.mulaiGejala+1==model.maksGejala){
                              String kode = model.dataGejala[model.mulaiGejala]['kode_gejala'];
                              print (kode + ": "+model.jawaban.toString());
                              insertJawaban(kode,model.jawaban);
                              print('habis bro');
                              prosesKonsul();

                            }else
                            if(model.select_tidak==true||model.select_mungkin==true||model.select_iya==true){
                              setState(() {
                                String kode = model.dataGejala[model.mulaiGejala]['kode_gejala'];
                                print (kode + ": "+model.jawaban.toString());
                                insertJawaban(kode,model.jawaban);
                                model.mulaiGejala = model.mulaiGejala + 1;
                                model.select_tidak = false;
                                model.select_mungkin = false;
                                model.select_iya =false;
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: model.fullWidth*0.4,
                            height: model.fullWidth*0.4,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                            ),
                            child: Center(
                              child:
                              model.select_tidak==true || model.select_mungkin==true || model.select_iya==true
                                  ?  Container(
                                child: model.mulaiGejala+1 < model.maksGejala?
                                Container(child: Image.asset('assets/images/next.png'))
                                    :   Container(child: Image.asset('assets/images/finish.png')),

//                                Text("${model.mulaiGejala+1 < model.maksGejala? 'Next>>' : 'Finish'}",style: TextStyle(fontSize: 40,color: Colors.blue))

                              )
                                  : Text("${model.mulaiGejala+1}",style: TextStyle(fontSize: 100,color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }


}
