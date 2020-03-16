import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/model/modeladmin.dart';
import 'package:gingivitis/activity/admin/user/detail_user.dart';


class KelolaUser extends StatefulWidget {
  @override
  _KelolaUserState createState() => _KelolaUserState();
}

class _KelolaUserState extends State<KelolaUser> {

  ModelminKelolaUser model = ModelminKelolaUser();

  Future<List> getData() async {
    final result = await http.get(link.LinkSource.getAllUser,);
    model.data = json.decode(result.body);
    return json.decode(result.body);
  }

  Future<Null> handleRefresh() async {
    Completer<Null> completer = new Completer<Null>();
    new Future.delayed(new Duration(milliseconds: 500)).then((_) {
      completer.complete();
      setState(() {
        if (model.reloadData == 0) {
          model.reloadData = 1;
        } else if (model.reloadData == 1) {
          model.reloadData = 0;
        }
      });
    });
    return completer.future;
  }

  Future<int> konfirm(String id, String nama)async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                "Konfirmasi"),
            content: Text("Apakah anda yakin menghapus $nama?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    hapus(id,nama);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Iya",
                    style:
                    TextStyle(color: Colors.green),
                  )),
              FlatButton(
                  onPressed: () =>
                      Navigator.pop(context),
                  child: Text("Tidak",
                      style: TextStyle(
                          color: Colors.red))),
            ],
          );
        });
  }

  Future<int> hapus(String id, String nama)async{
    final result = await http.post(link.LinkSource.hapusUser, body: {
      "id": id,
    });
    String msg = result.body;
    if(msg=="suk"){
      Fluttertoast.showToast(msg: '$nama dihapus',textColor: Colors.white,backgroundColor: Colors.green);
    }else{
      Fluttertoast.showToast(msg: 'gagal menghapus',textColor: Colors.white,backgroundColor: Colors.red);
    }
    handleRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kelola User"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.group_add),
        onPressed: ()=>Navigator.pushNamed(context, '/tambahuser'),
      ),
      body: Container(
        child: FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot){
            if(snapshot.hasError)print(snapshot.error);
            return snapshot.hasData ?
                RefreshIndicator(
                  onRefresh: handleRefresh,
                  child: ListView.builder(itemCount: snapshot.data.length,
                    itemBuilder: (context, i){
                      return ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(5),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue.withOpacity(0.5)),
                          child: Center(
                              child: Image.asset("${snapshot.data[i]['jk']=="laki-laki" ? "assets/images/man.png" : "assets/images/girl.png"}",fit: BoxFit.cover,)
                          ),
                        ),
                        title: Text(snapshot.data[i]['nama'].toString().toUpperCase()),
                        subtitle: Text("${snapshot.data[i]['alamat']==null || snapshot.data[i]['alamat']==""? "-":snapshot.data[i]['alamat'].toString().toUpperCase()}"),
                        trailing: Text("${snapshot.data[i]['tgl_lahir']==null ||snapshot.data[i]['tgl_lahir']==""? "-" : snapshot.data[i]['tgl_lahir']=="" ? "NULL" : cariUmur(snapshot.data[i]['tgl_lahir'])+" th" }"),
                        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>DetailUser(id: snapshot.data[i]['id_user'].toString(),))),
                        onLongPress: (){
                          konfirm(snapshot.data[i]['id_user'], snapshot.data[i]['nama']);
                        },
                      );
                    },),
                )
                : Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }

  cariUmur(String date){

    DateTime now = DateTime.now();
    String strUmur="";

    String tahunNow = now.year.toString();
    print(date);
    String tahunLahir = date.substring(0,4);
    int umur=0;
    umur = int.parse(tahunNow) - int.parse(tahunLahir);
    strUmur = umur.toString();

    return strUmur;
  }
}
