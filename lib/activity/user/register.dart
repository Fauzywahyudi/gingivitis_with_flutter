import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/sqlite/DBHelper.dart';
import 'package:http/http.dart' as http;
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:gingivitis/model/model.dart';
import 'package:gingivitis/activity/user/login_user.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  ModelRegister model = ModelRegister();

  Future<int> addDataDiri(String nama, String username, String password, int jk, String nohp) async {
    var db = DBHelper();
    String jekel;
    if (jk == 1) {
      jekel = "laki-laki";
    } else if (jk == 2) {
      jekel = "perempuan";
    }

    final result = await http.post(link.LinkSource.registerUser, body: {
      "nama"    : nama,
      "username": username,
      "password": password,
      "jk"      : jekel,
      "nohp"    : nohp,
    });
    print(result.body);
    String msg = result.body.substring(0,3);
    String id = result.body.substring(3);
    print("id user adalah : $id");


    if (msg=="suk") {
      int res = await db.addData(username, password, nama, int.parse(id),"aktif");
      print("res sqlite : $res");
      if(res==1){
        Fluttertoast.showToast(msg: "Pendaftaran berhasil", textColor: Colors.white,backgroundColor: Colors.green);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>LoginUser(username: username,)));
      }
    }else if(msg=="ada"){
      Fluttertoast.showToast(msg: "Username sudah terdaftar",backgroundColor: Colors.red,textColor: Colors.white);
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 50),
                    height: 200,
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        "Silahkan masukkan data anda",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Container(
                      height: 60,
                      color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pushReplacementNamed(
                                  context, '/loginuser')),
                          IconButton(
                              icon: Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pushReplacementNamed(
                                  context, '/loginadmin')),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: model.edc_username,
                        focusNode: model.foc_username,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (v) {
                          FocusScope.of(context).requestFocus(model.foc_password);
                        },
                        decoration: InputDecoration(labelText: "Username",
                          prefixIcon: Icon(Icons.contact_mail)
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: model.edc_password,
                        focusNode: model.foc_password,
                        textInputAction: TextInputAction.next,
                        obscureText: model.hidePass,
                        onSubmitted: (v) {
                          FocusScope.of(context).requestFocus(model.foc_nama);
                        },
                        decoration: InputDecoration(labelText: "Password",
                            prefixIcon: Icon(Icons.lock),
                          suffixIcon: model.hidePass? IconButton(icon: Icon(Icons.visibility,),onPressed: (){
                            setState(() {
                              model.hidePass = false;
                            });
                          },)
                              : IconButton(icon: Icon(Icons.visibility_off,),onPressed: (){
                            setState(() {
                              model.hidePass = true;
                            });
                          },)
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: model.edc_nama,
                        focusNode: model.foc_nama,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        onSubmitted: (v) {
                          FocusScope.of(context).requestFocus(model.foc_umur);
                        },
                        decoration: InputDecoration(labelText: "Nama Lengkap",
                            prefixIcon: Icon(Icons.person)
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(Icons.wc,color: Colors.black45,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Jenis Kelamin",
                                    style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Laki-laki",
                                        style: TextStyle(
                                            fontSize: 18, color: model.grupjk==1? Colors.blue: Colors.black45),
                                      ),
                                      Radio(
                                        value: 1,
                                        groupValue: model.grupjk,
                                        onChanged: (v) {
                                          rd_jk(v);
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Perempuan",
                                        style: TextStyle(
                                            fontSize: 18, color: model.grupjk==2? Colors.blue: Colors.black45),
                                      ),
                                      Radio(
                                        value: 2,
                                        groupValue: model.grupjk,
                                        onChanged: (v) {
                                          rd_jk(v);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),

                    Container(
                      margin: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: model.edc_nohp,
                        focusNode: model.foc_nohp,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (v) {
                          model.foc_nohp.unfocus();
                        },
                        keyboardType: TextInputType.numberWithOptions(),
                        decoration: InputDecoration(labelText: "No. HP",
                        prefixIcon: Icon(Icons.smartphone)
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20.0),
                      child: RaisedButton(
                        onPressed: () {
                          String nama = model.edc_nama.text;
                          String username = model.edc_username.text;
                          String password = model.edc_password.text;
                          int jk = model.grupjk;
                          String nohp = model.edc_nohp.text;

                          if(nama.isEmpty || username.isEmpty || password.isEmpty || jk.toString().isEmpty){
                            Fluttertoast.showToast(msg: "Mohon lengkapi data anda",backgroundColor: Colors.red,textColor: Colors.white);
                          }else{
                            addDataDiri(nama,username,password,jk,nohp);
                          }


                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Simpan",
                              style:
                              TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void rd_jk(int v) {
    setState(() {
      if (v == 1) {
        model.grupjk = 1;
      } else if (v == 2) {
        model.grupjk = 2;
      }
    });
  }
}
