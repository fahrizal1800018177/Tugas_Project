import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'profil.dart';
import 'menusaldo.dart';
import 'menuhutang.dart';
import 'package:table_calendar/table_calendar.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
      
    );
  }
}

// untuk menuUtama
class Menu extends StatefulWidget {
  final VoidCallback signOut;
  Menu(this.signOut);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  String username = "", nama = "";
  String gambar1 = "img/logo.png";
  TabController controller;

  get list => null;
  
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    signOut();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      nama = preferences.getString("nama");
    });
  }


  @override
  void initState() {
    controller = TabController(vsync: this, length: 2);
    super.initState();
    getPref();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CashKu",
          style: TextStyle(fontSize: 25.0),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              signOut();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff096ff), Color(0xff6610f2)],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight),
        )),
        bottom: TabBar(
          controller: controller,
          labelColor: Colors.white,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.account_balance_wallet),
              text: "Saldo",
            ),
            Tab(
              icon: Icon(Icons.local_atm),
              text: "Hutang",
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("$nama"),
              accountEmail: Text("$username"),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return Profil();
                    },
                  ));
                },
                child: CircleAvatar(backgroundImage: AssetImage(gambar1)),
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('img/pattern2.jpeg'),
                      fit: BoxFit.cover)),
            ),
            ListTile(
              leading: Icon(Icons.account_circle, color: Colors.black),
              title: Text("Account", style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Account(),
                ));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.calendar_today,
                color: Colors.black,
              ), // untuk membuat icon kiri
              title: Text(
                "Calender",
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Calender()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: Colors.black,
              ), // untuk membuat icon kiri
              title: Text(
                "Info Aplikasi",
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => InfoAplikasi()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: new TabBarView(
          controller: controller,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Column(children: <Widget>[
                  Padding(padding: EdgeInsets.all(10.0)),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.teal,
                              Colors.lightBlue[700],
                            ])),
                    child: FlatButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return MenuSaldo();
                            },
                          ));
                        },
                        child: Text(
                          "SALDO",
                          style: TextStyle(color: Colors.white, fontSize: 30.0),
                        )),
                  ),
                  Flexible(child: Center(child: Image.asset("img/saldo.png")))
                ]),
                Align(
                    alignment: Alignment(0, -0.55),
                    child: Text("Rp. 0",
                     style: TextStyle(fontSize: 30.0))),
              ],
            ),
            Stack(
              children: <Widget>[
                Column(children: <Widget>[
                  Padding(padding: EdgeInsets.all(10.0)),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.teal,
                              Colors.lightBlue[700],
                            ])),
                    child: FlatButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return MenuHutang();
                            },
                          ));
                        },
                        child: Text(
                          "HUTANG",
                          style: TextStyle(color: Colors.white, fontSize: 30.0),
                        )),
                  ),
                  Flexible(child: Center(child: Image.asset("img/hutang.jpeg")))
                ]),
                Align(
                    alignment: Alignment(0, -0.55),
                    child: Text("Rp. 0", 
                    style: TextStyle(fontSize: 30.0))),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        color: Colors.teal,
        child: TabBar(
          controller: controller,
          labelColor: Colors.white,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.account_balance_wallet),
            ),
            Tab(
              icon: Icon(Icons.local_atm),
            ),
          ],
        ),
      ),
    );
  }
}

// untuk Account
class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Account"),
      ),
      body: ListView(children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.enhanced_encryption,
            color: Colors.black,
          ),
          title: Text(
            "Kemanan",
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Keamanan()));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.delete,
            color: Colors.black,
          ),
          title: Text(
            "Hapus Account",
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ]),
    );
  }
}

// untuk keamanan dalam akun
class Keamanan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final alucard = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(
          radius: 72.0,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage('img/cashku.jpg'),
        ),
      ),
    );

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Keamanan CashKu',
        style: TextStyle(fontSize: 28.0, color: Colors.white),
      ),
    );

    final lorem = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Akun anda diamankan dengan enkripsi End to end',
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('img/pattern2.jpeg'), fit: BoxFit.cover)),
      child: Column(
        children: <Widget>[alucard, welcome, lorem],
      ),
    );

    return Scaffold(
      body: body,
    );
  }
}

// untuk kalender
class Calender extends StatefulWidget {
  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  CalendarController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Calender"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[TableCalendar(calendarController: _controller)],
      )),
    );
  }
}

// untuk info aplikasi
class InfoAplikasi extends StatelessWidget {
  static String tag = 'home-page';

  @override
  Widget build(BuildContext context) {
    final alucard = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(
          radius: 72.0,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage('img/cashku.jpg'),
        ),
      ),
    );

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Welcome CashKu',
        style: TextStyle(fontSize: 28.0, color: Colors.white),
      ),
    );

    final lorem = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec hendrerit condimentum mauris id tempor. Praesent eu commodo lacus. Praesent eget mi sed libero eleifend tempor. Sed at fringilla ipsum. Duis malesuada feugiat urna vitae convallis. Aliquam eu libero arcu.',
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('img/pattern2.jpeg'), fit: BoxFit.cover)),
      child: Column(
        children: <Widget>[alucard, welcome, lorem],
      ),
    );

    return Scaffold(
      body: body,
    );
  }
}
