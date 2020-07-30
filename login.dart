import 'package:cashku/url/api.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginState extends State<Login> {


  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String username, password;

  final _key = new GlobalKey<FormState>();

  bool _secureText = true;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    final response = await http.post(BaseUrl.login,
        body: {"username": username, "password": password});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    String usernameAPI = data['username'];
    String namaAPI = data['nama'];
    String id = data['id'];
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, usernameAPI, namaAPI, id);
      });
      print(pesan);
    } else {
      print(pesan);
    }
    print(data);
  }

  savePref(int value, String username, String nama, String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("nama", nama);
      preferences.setString("username", username);
      preferences.setString("id", id);
      preferences.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  double getSmallDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 2 / 3;
  double getBigDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 7 / 8;

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
            backgroundColor: Color(0xFFEEEEEE),
            body: Stack(
              children: <Widget>[
                Positioned(
                  right: -getSmallDiameter(context) / 3,
                  top: -getSmallDiameter(context) / 3,
                  child: Container(
                      width: getSmallDiameter(context),
                      height: getSmallDiameter(context),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              colors: [Colors.yellow, Colors.lightBlue],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter))),
                ),
                Positioned(
                  left: -getSmallDiameter(context) / 3,
                  top: -getSmallDiameter(context) / 3,
                  child: Container(
                      child: Center(
                        child: Text("CashKu",
                            style:
                                TextStyle(fontSize: 30, color: Colors.white)),
                      ),
                      width: getBigDiameter(context),
                      height: getBigDiameter(context),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              colors: [Colors.yellow, Colors.lightBlue],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter))),
                ),
                Positioned(
                  right: -getBigDiameter(context) / 2,
                  bottom: -getBigDiameter(context) / 2,
                  child: Container(
                      width: getBigDiameter(context),
                      height: getBigDiameter(context),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFFF3E9EE))),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Form(
                      key: _key,
                      child: ListView(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            margin: EdgeInsets.fromLTRB(20, 250, 20, 10),
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 25),
                            child: Column(children: <Widget>[
                              TextFormField(
                                validator: (e) {
                                  if (e.isEmpty) {
                                    return "Please insert username / email";
                                  }
                                },
                                onSaved: (e) => username = e,
                                decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.email,
                                      color: Color(0xFFFF4891),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.lightBlue)),
                                    labelText: "Username / Email",
                                    hintText: "Username / Email",
                                    labelStyle:
                                        TextStyle(color: Color(0xFFFF4891))),
                              ),
                              TextFormField(
                                obscureText: _secureText,
                                onSaved: (e) => password = e,
                                decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.vpn_key,
                                      color: Color(0xFFFF4891),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.lightBlue)),
                          
                                    labelText: "Password",
                                    labelStyle:
                                        TextStyle(color: Color(0xFFFF4891)),
                                    suffixIcon: IconButton(
                                      icon: Icon(_secureText
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onPressed: showHide,
                                    )),
                              ),
                            ]),
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 20, 20),
                                child: Text("FORGOT PASSWORD ?",
                                    style: TextStyle(
                                        color: Color(0xFFFF4891),
                                        fontSize: 13.0)),
                              )),
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height: 40,
                                  child: Container(
                                      child: Material(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          splashColor: Colors.amber,
                                          onTap: () {
                                            check();
                                          },
                                          child: Center(
                                            child: Text("SIGN IN",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.yellow,
                                                Colors.lightBlue,
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter))),
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "DON'T HAVE AN ACCOUNT ? ",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.lightBlue,
                                    fontWeight: FontWeight.w500),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Register();
                                  }));
                                },
                                child: Text(
                                  "SIGN UP",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFFFF4891),
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ))
              ],
            ));
        break;
      case LoginStatus.signIn:
        return Menu(signOut);
    }
  }
}
