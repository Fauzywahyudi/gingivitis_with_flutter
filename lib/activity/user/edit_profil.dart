import 'dart:async';
import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/sqlite/DBHelper.dart';
import 'package:http/http.dart' as http;
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:gingivitis/model/model.dart';

class EditProfil extends StatefulWidget {
  @override
  _EditProfilState createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  ModelEditProfil model = ModelEditProfil();

  Future<List> getDataUser() async {
    var db = new DBHelper();
    List<Map> list = await db.getData();
    setState(() {
      model.nama = list[0]['nama'];
      model.id = list[0]['id'];
    });

    print("id adalah " + model.id.toString());

    final result = await http.post(link.LinkSource.getUser, body: {
      "id": model.id.toString(),
    });

    setState(() {
      model.dataUser = json.decode(result.body);
      model.jekel = model.dataUser[0]['jk'];
      model.tmp_lahir = model.dataUser[0]['tmp_lahir'];
      model.tgl_lahir = model.dataUser[0]['tgl_lahir'];
      model.alamat = model.dataUser[0]['alamat'];
      model.nohp = model.dataUser[0]['nohp'];
      model.tgl_daftar = model.dataUser[0]['tgl_daftar'];

      model.edc_nama.text = model.nama;
      model.edc_alamat.text = model.alamat;
      model.edc_tmplahir.text = model.tmp_lahir;
      model.edc_nohp.text = model.nohp;
      model.edc_tgllahir.text= model.tgl_lahir;
    });

    print(model.dataUser);

    if (model.dataUser[0]['jk'] == "laki-laki") {
      setState(() {
        model.jk = 1;
        model.grupjk = 1;
      });
    } else {
      setState(() {
        model.jk = 0;
        model.grupjk = 2;
      });
    }
    print(model.nama);
  }

  Future<int> simpan(String nama, String tmp_lahir, String tgl_lahir, String alamat, String nohp, int jk)async{
    var db = new DBHelper();
    String jekel = "";
    if(jk==1){
      setState(() {
        jekel = "laki-laki";
      });
    }else{
      setState(() {
        jekel = "perempuan";
      });
    }

    final result = await http.post(link.LinkSource.editProfil, body: {
      "id": model.id.toString(),
      "nama": nama,
      "jk": jekel,
      "tmp_lahir": tmp_lahir,
      "tgl_lahir": tgl_lahir,
      "alamat": alamat,
      "nohp": nohp,
    });

    print(result.body);
    int res = await db.editAkun(model.id, nama);
    print(res.toString());
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/profil');

  }

  @override
  void initState() {
    getDataUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profil"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
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
                decoration: InputDecoration(labelText: "Nama Lengkap",prefixIcon: Icon(Icons.person)),
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
                                    TextStyle(fontSize: 18, color: model.grupjk==1?Colors.blue: Colors.black45),
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
                                    TextStyle(fontSize: 18, color: model.grupjk==2?Colors.blue: Colors.black45),
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
                decoration: InputDecoration(labelText: "Tempat Lahir",prefixIcon: Icon(Icons.add_location)),
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
                  onFieldSubmitted: (dt){
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
                decoration: InputDecoration(labelText: "Alamat",prefixIcon: Icon(Icons.location_on)),
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
                decoration: InputDecoration(labelText: "No. HP",prefixIcon: Icon(Icons.smartphone)),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20.0),
              child: RaisedButton(
                onPressed: () {
                  model.foc_nohp.unfocus();
                  String nama = model.edc_nama.text;
                  String tmp_lahir = model.edc_tmplahir.text;

                  String tgl_lahir = model.edc_tgllahir.text;

                  String alamat = model.edc_alamat.text;
                  String nohp = model.edc_nohp.text;
                  int jk = model.grupjk;
                  if(tgl_lahir==null||tgl_lahir==""){
                    Fluttertoast.showToast(msg: "Tanggal lahir tidak boleh kosong",textColor: Colors.white,backgroundColor: Colors.red);
                  }else{
                    simpan(nama, tmp_lahir, tgl_lahir, alamat, nohp, jk);
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
