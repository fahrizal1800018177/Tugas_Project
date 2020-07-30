import 'dart:convert';
import 'package:cashku/dataPemasukkan.dart';
import 'package:cashku/url/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

// untuk menu saldo
class MenuSaldo extends StatefulWidget {
  static String tag = 'menusaldo';
  @override
  _MenuSaldoState createState() => new _MenuSaldoState();
}

class _MenuSaldoState extends State<MenuSaldo>
    with SingleTickerProviderStateMixin {
  TabController controller;

  var loading = false;
  final list = new List<KeteranganDataPemasukkan>();

  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.lihat);
    if (response.contentLength == 2) {
    } else {
      var data = jsonDecode(response.body);
      data.forEach((api) {
        var tampil = new KeteranganDataPemasukkan(
            api['id'],
            api['saldo'],
            api['pemasukkan'],
            api['waktu'],
            api['keterangan'],
            api['idUsers'],
            api['nama']);
        list.add(tampil);
      });
      setState(() {
        loading = false;
      });
    }
  }

  // untuk dialog delete
  dialogDelete(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Text("Are You Sure Want to Delete this Data ?"),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          _delete(id);
                        },
                        child: Text("Yes")),
                    SizedBox(
                      width: 16.0,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                  ],
                )
              ],
            ),
          );
        });
  }

  _delete(String id) async {
    final response = await http.post(BaseUrl.hapus, body: {"idData": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];

    if (value == 1) {
      print(message);
      setState(() {
        Navigator.pop(context);
        _lihatData();
      });
    } else {
      print(message);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new TabController(vsync: this, length: 2);
    _lihatData();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  var signOut;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return Menu(signOut);
              }));
            }),
        title: Text(
          "Saldo",
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff096ff), Color(0xff6610f2)],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight),
        )),
        bottom: TabBar(controller: controller, tabs: <Widget>[
          Tab(icon: Icon(Icons.account_balance_wallet), text: "Pemasukan"),
          Tab(icon: Icon(Icons.description), text: "Keterangan"),
        ]),
      ),
      body: Center(
        child: new TabBarView(
          controller: controller,
          children: <Widget>[
            Stack(children: <Widget>[
              Column(children: <Widget>[
                Padding(padding: EdgeInsets.all(16.0)),
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
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MenuPemasukkan(),
                        ));
                      },
                      child: Text(
                        "PEMASUKKAN",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      )),
                ),
                Flexible(child: Center(child: Image.asset("img/masuk.png")))
              ]),
            ]),
            Scaffold(
                body: RefreshIndicator(
              onRefresh: _lihatData,
              key: _refresh,
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final x = list[i];
                        return Container(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Nama : " + x.nama),
                        
                                        Text("Pemasukkan : Rp." + x.pemasukkan),
                                        Text("Keterangan : " + x.keterangan),
                                        Text("Waktu : " + x.waktu),
                                      ]),
                                ),
                                IconButton(
                                    icon: Icon(Icons.edit, color: Colors.teal),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) => EditData(x),
                                      ));
                                    }),
                                IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      dialogDelete(x.id);
                                    }),
                              ],
                            ));
                      }),
            )),
          ],
        ),
      ),
      bottomNavigationBar: new Material(
        color: Colors.teal,
        child: new TabBar(
          controller: controller,
          labelColor: Colors.white,
          tabs: <Widget>[
            new Tab(
              icon: new Icon(Icons.account_balance_wallet),
            ),
            new Tab(
              icon: new Icon(Icons.description),
            ),
          ],
        ),
      ),
    );
  }
}

// untuk form pemasukkan / tambah data
class MenuPemasukkan extends StatefulWidget {
  @override
  _MenuPemasukkanState createState() => _MenuPemasukkanState();
}

class _MenuPemasukkanState extends State<MenuPemasukkan> {
  String pemasukkan, keterangan, idUsers;
  final _key = new GlobalKey<FormState>();

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      add();
    }
  }

  add() async {
    final response = await http.post(BaseUrl.tambah, body: {
      "pemasukkan": pemasukkan,
      "keterangan": keterangan,
      "idUsers": idUsers,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      print(pesan);
      setState(() {
        // widget.reload();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MenuSaldo(),
        ));
      });
    } else {
      print(pesan);
    }
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
        title: Text("Pemasukkan"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return MenuSaldo();
              }));
            }),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  onSaved: (e) => pemasukkan = e,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.attach_money),
                    prefixText: "Rp. ",
                    prefixStyle: TextStyle(color: Colors.black, fontSize: 16.0),
                    labelText: "Pemasukkan",
                    hintText: "Jumlah Pemasukkan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                TextFormField(
                  onSaved: (e) => keterangan = e,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.description),
                      labelText: "Keterangan",
                      hintText: "Keterangannya",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
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
                      onPressed: () {
                        check();
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      )),
                )
              ]),
        ),
      ),
    );
  }
}

// untuk edit data
class EditData extends StatefulWidget {
  final KeteranganDataPemasukkan editData;
  EditData(this.editData);
  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  final _key = new GlobalKey<FormState>();
  String pemasukkan, keterangan;

  TextEditingController txtPemasukkan, txtKeterangan;
  setUp() {
    txtPemasukkan = TextEditingController(text: widget.editData.pemasukkan);
    txtKeterangan = TextEditingController(text: widget.editData.keterangan);
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      edit();
    } else {}
  }

  @override
  void initState() {
    super.initState();
    setUp();
  }

  edit() async {
    final response = await http.post(BaseUrl.edit, body: {
      "pemasukkan": pemasukkan,
      "keterangan": keterangan,
      "idData": widget.editData.id
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      setState(() {
        print(message);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MenuSaldo(),
        ));
      });
    } else {
      print(message);
    }
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
                return MenuSaldo();
              }));
            }),
        title: Text("Edit Data"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: Column(children: <Widget>[
            TextFormField(
              controller: txtPemasukkan,
              onSaved: (e) => pemasukkan = e,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.attach_money),
                  prefixText: "Rp. ",
                  prefixStyle: TextStyle(color: Colors.black, fontSize: 16.0),
                  labelText: "Pemasukkan",
                  hintText: "Jumlah Pemasukkan",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
            Padding(padding: EdgeInsets.all(10.0)),
            TextFormField(
              controller: txtKeterangan,
              onSaved: (e) => keterangan = e,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.description),
                  labelText: "Keterangan",
                  hintText: "Keterangannya",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
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
                  onPressed: () {
                    check();
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}
