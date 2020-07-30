import 'package:cashku/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  var signOut;
  String nama = '', email = '';
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nama = preferences.getString("nama");
      email = preferences.getString("username");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return Menu(signOut);
                }));
              }),
          title: Text("Profil"),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(children: <Widget>[
              Align(
                  alignment: Alignment(0, -0.85),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(70.0),
                      child: Container(
                          width: 150,
                          height: 150,
                          child: Image(
                            fit: BoxFit.cover,
                            image: AssetImage("img/logo.png"),
                          )))),
              Padding(padding: EdgeInsets.all(10.0)),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditNama(),
                            ));
                      },
                      child: Container(
                          padding: EdgeInsets.all(20.0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.person,
                                  size: 30.0, color: Colors.lightBlue),
                              Padding(padding: EdgeInsets.all(10.0)),
                              Text("$nama",
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.lightBlue)),
                              IconButton(
                                  padding: EdgeInsets.fromLTRB(120.0, 0, 0, 0),
                                  icon: Icon(Icons.edit),
                                  onPressed: () {})
                            ],
                          )),
                    ),
                    Container(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.email,
                                size: 30.0, color: Colors.lightBlue),
                            Padding(padding: EdgeInsets.all(10.0)),
                            Text("$email",
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.lightBlue)),
                          ],
                        )),
                  ],
                ),
              ),
            ]),
          ),
        ));
  }
}

class EditNama extends StatefulWidget {
  @override
  _EditNamaState createState() => _EditNamaState();
}

class _EditNamaState extends State<EditNama> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Edit Nama"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.teal,
                          Colors.lightBlue[700],
                        ])),
                child: FlatButton(
                    onPressed: () {},
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    )),
              ),
            ],
          )),
    );
  }
}
