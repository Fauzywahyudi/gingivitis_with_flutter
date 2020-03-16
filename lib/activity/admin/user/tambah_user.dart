import 'dart:async';
import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/sqlite/DBHelper.dart';
import 'package:http/http.dart' as http;
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:gingivitis/model/modeladmin.dart';
import 'package:gingivitis/activity/admin/user/detail_user.dart';

class TambahUser extends StatefulWidget {
  @override
  _TambahUserState createState() => _TambahUserState();
}

class _TambahUserState extends State<TambahUser> {
  ModelminTambahUser model = ModelminTambahUser();

  Future<int> simpan() async {
    print('mulai');
    String jekel = "";
    if (model.grupjk == 1) {
      setState(() {
        jekel = "laki-laki";
      });
    } else {
      setState(() {
        jekel = "perempuan";
      });
    }

    final result = await http.post(link.LinkSource.addUser, body: {
      "username": model.edc_username.text,
      "password": model.edc_password.text,
      "nama": model.edc_nama.text,
      "jk": jekel,
      "tmp_lahir": model.edc_tmplahir.text,
      "tgl_lahir": model.edc_tgllahir.text,
      "alamat": model.edc_alamat.text,
      "nohp": model.edc_nohp.text,
    });

    if(result.body=="ada"){
      Fluttertoast.showToast(msg: "Username sudah ada", textColor: Colors.white, backgroundColor: Colors.red);
    }else if(result.body=="suk"){
      Fluttertoast.showToast(msg: "Sukses menambahkan", textColor: Colors.white, backgroundColor: Colors.green);
      Navigator.pop(context);
    }else if(result.body=="gag"){
      Fluttertoast.showToast(msg: "Gagal menambahkan", textColor: Colors.white, backgroundColor: Colors.red);
    }

    print(result.body);
//    int res = await db.editAkun(model.id, nama);
//    print(res.toString());
//    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah User"),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.only(top: 0),
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
                decoration: InputDecoration(
                    labelText: "Username",
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
                  FocusScope.of(context).requestFocus(model.foc_nama);
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
              margin: const EdgeInsets.all(8.0),
              child: TextField(
                controller: model.edc_nama,
                focusNode: model.foc_nama,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                onSubmitted: (v) {
                  FocusScope.of(context).requestFocus(model.foc_tmplahir);
                },
                decoration: InputDecoration(
                    labelText: "Nama Lengkap", prefixIcon: Icon(Icons.person)),
              ),
            ),
            Container(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Jenis Kelamin",
                        style: TextStyle(fontSize: 18, color: Colors.black45),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "Laki-laki",
                                style:
                                    TextStyle(fontSize: 18, color: model.grupjk==1? Colors.blue :Colors.black45),
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
                                style:
                                    TextStyle(fontSize: 18, color: model.grupjk==2? Colors.blue :Colors.black45),
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
                controller: model.edc_tmplahir,
                focusNode: model.foc_tmplahir,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                onSubmitted: (v) {
                  FocusScope.of(context).requestFocus(model.foc_alamat);
                },
                decoration: InputDecoration(
                    labelText: "Tempat Lahir",
                    prefixIcon: Icon(Icons.add_location)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DateTimePickerFormField(
                  style: TextStyle(fontSize: 16.0),
                  focusNode: model.foc_tgllahir,
                  controller: model.edc_tgllahir,
                  inputType: model.inputType,
                  format: model.formats[model.inputType],
//                  editable: model.editable,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.date_range,
                    ),
                    labelText: 'Tanggal Lahir',
//                    labelStyle: TextStyle(color: Colors.blue, fontSize: 16.0),
                    hasFloatingPlaceholder: false,
                  ),
                  onFieldSubmitted: (dt) {
                    model.foc_tgllahir.unfocus();
                  },
                  onChanged: (dt) {
                    setState(() => model.date = dt);
                  }),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: TextField(
                controller: model.edc_alamat,
                focusNode: model.foc_alamat,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                onSubmitted: (v) {
                  FocusScope.of(context).requestFocus(model.foc_nohp);
                },
                decoration: InputDecoration(
                    labelText: "Alamat", prefixIcon: Icon(Icons.location_on)),
              ),
            ),
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
                decoration: InputDecoration(
                    labelText: "No. HP", prefixIcon: Icon(Icons.smartphone)),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20.0),
              child: RaisedButton(
                onPressed: () {
                  model.foc_nohp.unfocus();
                  String username = model.edc_username.text;
                  String pass = model.edc_password.text;
                  String nama = model.edc_nama.text;

                  if(model.grupjk==null || username.isEmpty || pass.isEmpty || nama.isEmpty){
                    Fluttertoast.showToast(msg: "Mohon lengkapi data",backgroundColor: Colors.red, textColor: Colors.white);
                  }else{

                    simpan();
                  }

                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Tambah",
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
