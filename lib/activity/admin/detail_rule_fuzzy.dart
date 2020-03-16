import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:http/http.dart' as http;
import 'package:gingivitis/model/modeladmin.dart';

class DetailRuleFuzzy extends StatefulWidget {
  DetailRuleFuzzy({this.kode_rule});

  final String kode_rule;

  @override
  _DetailRuleFuzzyState createState() => _DetailRuleFuzzyState();
}

class _DetailRuleFuzzyState extends State<DetailRuleFuzzy> {
  ModelminDetailRule model = new ModelminDetailRule();

  Future<List> getDetailRule() async {
    final result = await http.post(link.LinkSource.getDetailRule, body: {
      "kode_rule": widget.kode_rule,
    });
    setState(() {
      model.dataRule = json.decode(result.body);
      var value = model.dataRule[0]['rule'];
      model.rule = value.split(".");
    });

//    print(model.rule[0]);
//    print(json.decode(result.body));
    return json.decode(result.body);
  }

  Future<List> getGejala() async {
    final result = await http.get(link.LinkSource.getGejala);
    model.dataGejala = json.decode(result.body);
    setState(() {
      model.totalGejala = model.dataGejala.length;
    });
//    print(model.totalGejala.toString());
//    print(model.dataGejala[0]['kode_gejala']);
    return json.decode(result.body);
  }

  @override
  void initState() {
//    getGejala();
    getDetailRule();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kode_rule),
      ),
//      floatingActionButton: FloatingActionButton(
//        child: Icon(
//          Icons.edit,
//        ),
//        tooltip: 'Edit Rule',
//      ),
      body: Container(
          child: FutureBuilder<List>(
        future: getGejala(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          i > 0
                              ? Padding(
                                  child: Text(
                                    "AND ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                  padding: EdgeInsets.only(bottom: 15),
                                )
                              : Container(),
                          Text(
                            snapshot.data[i]['kode_gejala'] +
                                " is " +
                                "${model.rule[i] == "1" ? "Iya" : model.rule[i] == "0" ? "Mungkin" : "Tidak"}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          i + 1 == model.totalGejala
                              ? Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          "THEN ",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold, color: Colors.green)),
                                      Padding(
                                        padding: EdgeInsets.only(top: 15),
                                        child: Text(
                                            "P01 is " +
                                                "${model.dataRule[0]['output'] == "1" ? "KHRONIS" : model.dataRule[0]['output'] == "0" ? "AKUT" : "TIDAK"}",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      )),
    );
  }
}
