import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/model/modeladmin.dart';
import 'package:gingivitis/activity/admin/user/edit_user.dart';
import 'package:gingivitis/activity/admin/user/detail_user.dart';

class UbahPassword extends StatefulWidget {
  UbahPassword({this.id,this.pass});
  final String id;
  final String pass;
  @override
  _UbahPasswordState createState() => _UbahPasswordState();
}

class _UbahPasswordState extends State<UbahPassword> {

  ModelminUbahPassword model = ModelminUbahPassword();

  Future simpan()async{
    final result = await http.post(link.LinkSource.ubahPassword,body: {
      "id" : widget.id,
      "password" : model.edc_password.text,
    });
    if(result.body=="suk"){
      Fluttertoast.showToast(msg: "Berhasil diubah",backgroundColor: Colors.green, textColor: Colors.white);
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>DetailUser(id: widget.id,)));
    }else{
      Fluttertoast.showToast(msg: "Terjadi kesalahan, silahkan ulangi lagi",backgroundColor: Colors.red, textColor: Colors.white);
    }
  }

  @override
  void initState() {
    setState(() {
      model.edc_password.text=widget.pass;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubah Password"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(8.0),
              child: TextField(
                controller: model.edc_password,
                focusNode: model.foc_password,
                textInputAction: TextInputAction.next,
                obscureText: model.hidePass,
                onSubmitted: (v) {

                },
                decoration: InputDecoration(
                    suffixIcon: model.hidePass ? IconButton(icon: Icon(Icons.visibility,), onPressed: (){
                      setState(() {
                        model.hidePass = false;
                      });
                    })
                        : IconButton(icon: Icon(Icons.visibility_off,), onPressed: (){
                      setState(() {
                        model.hidePass = true;
                      });
                    }),
                    labelText: "Password", prefixIcon: Icon(Icons.lock)),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20.0),
              child: RaisedButton(
                onPressed: () {
                  model.foc_password.unfocus();

                  if(model.edc_password.text==null|| model.edc_password.text==""){
                    Fluttertoast.showToast(msg: "Password tidak boleh kosong",backgroundColor: Colors.red, textColor: Colors.white);
                  }else{
                    simpan();
                  }

                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Simpan",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
