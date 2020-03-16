import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/model/modeladmin.dart';
import 'package:gingivitis/activity/admin/pembentukan_rule.dart';
class HasilPelatihan extends StatefulWidget {
  @override
  _HasilPelatihanState createState() => _HasilPelatihanState();
}

class _HasilPelatihanState extends State<HasilPelatihan> {

  ModelminHasilPelatihan model = new ModelminHasilPelatihan();

  Future<List> getData() async {
    final res1 = await http.post(link.LinkSource.hasilPelatihan, body: {
      "type": "0",
    });
    setState(() {
      model.jumlahData = double.parse(res1.body);
    });

    final res2 = await http.post(link.LinkSource.hasilPelatihan, body: {
      "type": "1",
    });
    model.data = json.decode(res2.body);
    print("epoch nya adalah" + model.data[0]['epoch']);
    setState(() {
      model.epoch = int.parse(model.data[0]['epoch']);
      model.bestBias = double.parse(model.data[0]['bias_baru']);
      model.bestBobot = model.data[0]['bobot_baru'];
    });

  }

  Future<List> getProses() async {
    final result = await http.get(link.LinkSource.showProsesPelatihan);
    return json.decode(result.body);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.title),
        actions: <Widget>[
          model.showProses
              ? IconButton(
            onPressed: () {
              setState(() {
                model.showProses = false;
                model.title = "Hasil Pelatihan";
              });
            },
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
          )
              : Container()
        ],
      ),
      body: model.showProses
          ? show()
          : Container(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Jumlah data pelatihan : " +
                    model.jumlahData.toString(),
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Iterasi berhenti setelah Epoch : " +
                    model.epoch.toString(),
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Best bias yang didapatkan  : " +
                    model.bestBias.toString(),
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Best bobot yang didapatkan  : \n " +
                    model.bestBobot.replaceAll(";", " * "),
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Center(
              child: RaisedButton(
                child: Container(
                  child: Text(
                    "Lihat Proses",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    model.showProses = true;
                    model.title = "Proses Pelatihan";
                  });
                },
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget show() {
    return Container(
      child: Stack(
        children: <Widget>[

          Container(
            margin: EdgeInsets.only(top: 20),
            child: FutureBuilder<List>(
              future: getProses(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData ?
                ListView.builder(itemCount: snapshot.data.length,
                itemBuilder: (context, i){
                  return ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      child: Center(
                          child: Text(
                            snapshot.data[i]['epoch'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
                      decoration: BoxDecoration(color: Colors.blue,shape: BoxShape.circle),
                    ),
                    title: Text(snapshot.data[i]['bobot_baru']
                        .toString()
                        .replaceAll(';', '     ')),
                    trailing: Text(snapshot.data[i]['bias_baru']),
                    onLongPress: () {
                    },
                    onTap: () {
                    },
                  );
                },)
                    : CircularProgressIndicator();
              },
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width*0.2,
                  height: 20,
                  child: Center(child: Text("Epoch")),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.65,
                  height: 20,
                  child: Center(child: Text("Bobot Baru")),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.15,
                  height: 20,
                  child: Center(child: Text("Bias")),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
