import 'package:flutter/material.dart';
import 'package:gingivitis/model/modeladmin.dart';
import 'package:gingivitis/sqlite/DBHelper.dart';
import 'package:http/http.dart' as http;
import 'package:gingivitis/mysql/link.dart' as link;
import 'package:gingivitis/activity/admin/home_admin.dart';

class LoginAdmin extends StatefulWidget {
  @override
  _LoginAdminState createState() => _LoginAdminState();
}

class _LoginAdminState extends State<LoginAdmin> {

  ModelminLogin model = new ModelminLogin();

  Future<int> loginAdmin(String username, String password) async {
    final result = await http.post(link.LinkSource.loginAdmin, body: {
      "username": username,
      "password": password,
    });

    String msg  = result.body.substring(0,1);
    String id   = result.body.substring(1);
    print(msg+id);
    if(msg=='1'){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeAdmin(id: id,)));
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
                        "Login Admin",
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pushReplacementNamed(
                                  context, '/splashscreen'))
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
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        onSubmitted: (v) {
                          model.foc_password.unfocus();
                        },
                        decoration: InputDecoration(labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.all(20.0),
                      child: RaisedButton(
                        onPressed: () {
                          String username = model.edc_username.text;
                          String password = model.edc_password.text;
                          loginAdmin(username, password);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Login",
                              style:
                              TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
