import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'login.dart';

class Register extends StatefulWidget {
  static String tag = 'register';
  @override
  _RegisterState createState() => _RegisterState();
}

enum RegisterStatus { notSignIn, signIn }

class _RegisterState extends State<Register> {
  String username, password, nama;
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
      register();
    }
  }

  register() async {
    final response = await http.post(
        "http://192.168.43.188/cashku/register.php",
        body: {"nama": nama, "username": username, "password": password});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return Login();
        }));
      });
      print(pesan);
    } else {
      print(pesan);
    }
  }

// untuk decoration
  double getSmallDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 2 / 3;

  double getBigDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 7 / 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE), // warna abu-abu ukuran 200
      body: Form(
        key: _key,
        child: Stack(children: <Widget>[
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
                    end: Alignment.bottomCenter,
                  )),
            ),
          ),
          Positioned(
            left: -getBigDiameter(context) / 4,
            top: -getBigDiameter(context) / 4,
            child: Container(
              child: Center(
                  child: Text(
                "Cashku",
                style: TextStyle(
                    fontFamily: "Pacifico", fontSize: 30, color: Colors.white),
              )),
              width: getBigDiameter(context),
              height: getBigDiameter(context),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.yellow, Colors.blue],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )),
            ),
          ),
          Positioned(
            right: -getBigDiameter(context) / 2,
            bottom: -getBigDiameter(context) / 2,
            child: Container(
              width: getBigDiameter(context),
              height: getBigDiameter(context),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: ListView(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    margin: EdgeInsets.fromLTRB(20, 250, 20, 10),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                    child: Column(children: <Widget>[
                      TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please Insert Fullname";
                            }
                          },
                          onSaved: (e) => nama = e,
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.person,
                                color: Color(0xFFFF4891),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Color(0xFFFF4891),
                              )),
                              labelText: "Nama Lengkap",
                              labelStyle: TextStyle(
                                color: Color(0xFFFF4891),
                              ))),
                      TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please Insert Username / Email";
                            }
                          },
                          onSaved: (e) => username = e,
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.email,
                                color: Color(0xFFFF4891),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Color(0xFFFF4891),
                              )),
                              labelText: "Username",
                              labelStyle: TextStyle(
                                color: Color(0xFFFF4891),
                              ))),
                      TextFormField(
                          obscureText: _secureText,
                          onSaved: (e) => password = e,
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.vpn_key,
                                color: Color(0xFFFF4891),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Color(0xFFFF4891),
                              )),
                              labelText: "Password",
                              suffixIcon: IconButton(
                                  icon: Icon(_secureText
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: showHide),
                              labelStyle: TextStyle(
                                color: Color(0xFFFF4891),
                              ))),
                    ]),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 30),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // untuk mengatur letak button
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 40,
                            child: Container(
                              child: Material(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.transparent,
                                child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    splashColor: Colors.amber,
                                    onTap: () {
                                      check();
                                    },
                                    child: Center(
                                      child: Text(
                                        "SIGN UP",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    )),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                      colors: [Colors.yellow, Colors.lightBlue],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)),
                            ),
                          )
                        ]),
                  ),
                ],
              ))
        ]),
      ),
    );
  }
}
