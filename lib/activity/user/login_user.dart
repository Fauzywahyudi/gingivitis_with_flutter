import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/sqlite/DBHelper.dart';
import 'package:http/http.dart' as http;
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:gingivitis/model/model.dart';

class LoginUser extends StatefulWidget {
  LoginUser({this.username});

  final String username;

  @override
  _LoginUserState createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  ModelLogin model = new ModelLogin();

  @override
  void initState() {
    if (widget.username == "") {
      model.edc_username.text = "";
    } else {
      model.edc_username.text = widget.username;
    }
    model.edc_password.text = "";
    super.initState();
  }

  Future<int> addDataDiri(
    int id,
    String nama,
    String username,
    String password,
  ) async {
    var db = DBHelper();
    int res = await db.addData(username, password, nama, id, 'aktif');
    if (res == 1) {
      print("recreate akun berhasil");
    }
    return res;
  }

  Future<int> cekAkun(int id, String username) async {
    var db = DBHelper();
    int res = await db.cekAkun(id, username);
    if (res == 1) {
      print("jumlah akun :$res");
    }
    setState(() {
      model.jum = res;
    });
    return res;
  }

  Future<int> login(String username, String password) async {
    setState(() {
      model.loading = true;
    });
    final result = await http.post(link.LinkSource.loginUser, body: {
      "username": username,
      "password": password,
    });
    String msg = result.body.substring(0, 1);
    print('msg : $msg');

    if (msg == "0") {
      setState(() {
        model.loading = false;
      });
      Fluttertoast.showToast(
          msg: "Username atau Password Salah",
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      setState(() {
        model.dataLogin = json.decode(result.body.substring(1));
        print(model.dataLogin.toString());
      });
      String user = model.dataLogin[0]['username'];
      String pass = model.dataLogin[0]['password'];
      String id = model.dataLogin[0]['id_user'];
      String nama = model.dataLogin[0]['nama'];

      cekAkun(int.parse(id), username);
      Timer(Duration(seconds: 2), () {
        if (model.jum > 0) {
          print("login klau ada");
          prosesLogin(int.parse(id), user, pass);
          setState(() {
            model.loading = false;
          });
          Fluttertoast.showToast(
              msg: "Login Berhasil",
              backgroundColor: Colors.green,
              textColor: Colors.white);
        } else {
          print("login klau tidak ada");
          addDataDiri(int.parse(id), nama, user, pass);

          Navigator.pushReplacementNamed(context, '/home');
          setState(() {
            model.loading = false;
          });
          Fluttertoast.showToast(
              msg: "Login Berhasil",
              backgroundColor: Colors.green,
              textColor: Colors.white);
        }
      });
    }
  }

  Future<int> prosesLogin(int id, String username, String password) async {
    var db = new DBHelper();
    int update = await db.updatePassword(id, password);
    Timer(Duration(seconds: 2), () {
      print("loading");
    });

    List result = await db.ceklogin(id);
    String pass = result[0]['password'];
    if (pass.isEmpty) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => LoginUser(
                    username: username,
                  )));
    } else {
      int res = await db.login(id);
      print('login code : $res');
      if (res == 1) {
        print('sukseslogin');
        Fluttertoast.showToast(
            msg: "Login Berhasil",
            backgroundColor: Colors.green,
            textColor: Colors.white);
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  Future<int> cekJumAkun(String type) async {
    var db = new DBHelper();
    int cek = await db.cekUser(type);
    if (cek == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: <Widget>[
                  Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                  Text("Warning"),
                ],
              ),
              content: Text("Tidak ditemukan akun anda."),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Oke", style: TextStyle(color: Colors.green))),
              ],
            );
          });
    } else {
      Navigator.pushReplacementNamed(context, '/pilihakun');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: model.loading
            ? Container(
          width: MediaQuery.of(context).size.width,
                child: Column(
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
                ),
              )
            : Container(
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
                                "Login User",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                            ),
                          ),
                          SafeArea(
                            child: Container(
                              height: 60,
                              color: Colors.blue,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(
                                        Icons.people,
                                        color: Colors.white,
                                      ),
                                      onPressed: () => cekJumAkun("jum")),
                                  IconButton(
                                      icon: Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      ),
                                      onPressed: () =>
                                          Navigator.pushReplacementNamed(
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
                                  FocusScope.of(context)
                                      .requestFocus(model.foc_password);
                                },
                                decoration:
                                    InputDecoration(labelText: "Username",
                                    prefixIcon: Icon(Icons.contact_mail)),
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
                                  model.foc_password.unfocus();
                                },
                                decoration:
                                    InputDecoration(labelText: "Password",
                                    prefixIcon: Icon(Icons.lock),
                                    suffixIcon: model.hidePass? IconButton(
                                      icon: Icon(Icons.visibility),
                                      onPressed: () {
                                        setState(() {
                                          model.hidePass=false;
                                        });
                                      },)
                                      : IconButton(
                                      icon: Icon(Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          model.hidePass=true;
                                        });
                                      },)

                                    ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(20.0),
                              child: RaisedButton(
                                onPressed: () {
                                  model.foc_password.unfocus();
                                  String username = model.edc_username.text;
                                  String password = model.edc_password.text;
                                  if (username.isEmpty || password.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Data tidak boleh kosong",
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white);
                                  } else {
                                    login(username, password);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Login",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ),
                                color: Colors.blue,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Anda belum mempunyai akun? "),
                                  InkWell(
                                    onTap: () => Navigator.pushReplacementNamed(
                                        context, '/register'),
                                    child: Text(
                                      "Daftar disini",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}
