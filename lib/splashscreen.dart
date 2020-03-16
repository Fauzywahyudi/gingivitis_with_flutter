import 'package:flutter/material.dart';
import 'package:gingivitis/sqlite/DBHelper.dart';
import 'package:gingivitis/model/model.dart';
import 'dart:async';
import 'package:gingivitis/activity/user/home.dart';
import 'package:gingivitis/activity/user/login_user.dart';
import 'package:gingivitis/activity/user/pilih_akun.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  ModelSplashscreen model = new ModelSplashscreen();

  Future<int> cek_user(String type) async {
    var db = DBHelper();
    int cek = await db.cekUser(type);
    setState(() {
      if (cek > 0) {
        model.isNew = false;
      } else {
        model.isNew = true;
      }
    });

    if (type == "aktif") {
      setState(() {
        model.aktif = cek;
      });
    } else {
      setState(() {
        model.jumlah = cek;
      });
    }

    print(cek.toString());
    return cek;
  }

  @override
  void initState() {
    cek_user("aktif");
    cek_user("jum");
    Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => model.aktif == 1
                ? new HomePage()
                : model.jumlah > 0 ? new PilihAkun() : new LoginUser())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width /2,
              height: MediaQuery.of(context).size.width /2,
              child: Image.asset(
                'assets/images/konsul.png',
                fit: BoxFit.cover,
              ),
            ),
            Text(
              "Diagnosa Gingivitis",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
//            Text("Loading...")
          ],
        ),
      ),
    );
  }
}
