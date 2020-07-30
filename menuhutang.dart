import 'dart:convert';
import 'package:cashku/dataPembayaran.dart';
import 'package:cashku/url/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

// untuk menu saldo
class MenuHutang extends StatefulWidget {
  static String tag = 'menuhutang';
  @override
  _MenuHutangState createState() => new _MenuHutangState();
}

class _MenuHutangState extends State<MenuHutang>
    with SingleTickerProviderStateMixin {
  TabController controller;
  var loading1 = false;
  final list1 = new List<KeteranganDataPembayaran>();

  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatDataPembayaran() async {
    list1.clear();
    setState(() {
      loading1 = true;
    });
    final response = await http.get(BaseUrl.lihatPembayaran);
    if (response.contentLength == 2) {
    } else {
      final data1 = jsonDecode(response.body);
      data1.forEach((api1) {
        final cd = new KeteranganDataPembayaran(
          api1['id'],
          api1['pembayaran'],
          api1['keterangan'],
          api1['waktu'],
          api1['idUsers'],
          api1['nama'],
        );
        list1.add(cd);
      });
      setState(() {
        loading1 = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new TabController(vsync: this, length: 2);
    _lihatDataPembayaran();
  }

  // untuk dialog delete
  dialogDeletePembayaran(String id) {
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
                          _deletePembayaran(id);
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

  _deletePembayaran(String id) async {
    final response =
        await http.post(BaseUrl.hapusPembayaran, body: {"idData": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];

    if (value == 1) {
      print(message);
      setState(() {
        Navigator.pop(context);
        _lihatDataPembayaran();
      });
    } else {
      print(message);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  signOut() {
    setState(() {
      signOut();
    });
  }

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
          "Hutang",
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
          Tab(icon: Icon(Icons.account_balance_wallet), text: "Pembayaran"),
          Tab(icon: Icon(Icons.description), text: "Keterangan"),
        ]),
      ),
      body: new Center(
        child: new TabBarView(
          controller: controller,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
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
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MenuPembayaran()));
                          },
                          child: Text(
                            "PEMBAYARAN",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0),
                          )),
                    ),
                    Flexible(child: Center(child: Image.asset("img/bayar.png")))
                  ],
                )
              ],
            ),
            Scaffold(
                body: RefreshIndicator(
              onRefresh: _lihatDataPembayaran,
              key: _refresh,
              child: loading1
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: list1.length,
                      itemBuilder: (context, i) {
                        final y = list1[i];
                        return Container(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Nama : " + y.nama),
                                        Text("Pembayaran : Rp." + y.pembayaran),
                                        Text("Keterangan : " + y.keterangan),
                                        Text("Waktu : " + y.waktu),
                                      ]),
                                ),
                                IconButton(
                                    icon: Icon(Icons.edit, color: Colors.teal),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) =>
                                            EditDataPembayaran(y),
                                      ));
                                    }),
                                IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      dialogDeletePembayaran(y.id);
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
class MenuPembayaran extends StatefulWidget {
  @override
  _MenuPembayaranState createState() => _MenuPembayaranState();
}

class _MenuPembayaranState extends State<MenuPembayaran> {
  String pembayaran, keterangan, idUsers;
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
      addPembayaran();
    }
  }

  addPembayaran() async {
    final response = await http.post(BaseUrl.tambahPembayaran, body: {
      "pembayaran": pembayaran,
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
          builder: (context) => MenuHutang(),
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
        title: Text("Pembayaran"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return MenuHutang();
              }));
            }),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: Column(children: <Widget>[
            TextFormField(
              onSaved: (e) => pembayaran = e,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.attach_money),
                  prefixText: "Rp. ",
                  prefixStyle: TextStyle(color: Colors.black, fontSize: 16),
                  labelText: "Pembayaran",
                  hintText: "Jumlah Pembayaran",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
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

class EditDataPembayaran extends StatefulWidget {
  final KeteranganDataPembayaran bayar;
  EditDataPembayaran(this.bayar);
  @override
  _EditDataPembayaranState createState() => _EditDataPembayaranState();
}

class _EditDataPembayaranState extends State<EditDataPembayaran> {
  final _key = new GlobalKey<FormState>();
  String pembayaran, keterangan;

  TextEditingController txtPembayaran, txtKeterangan;

  setUp() {
    txtPembayaran = TextEditingController(text: widget.bayar.pembayaran);
    txtKeterangan = TextEditingController(text: widget.bayar.keterangan);
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      editPembayaran();
    } else {}
  }

  @override
  void initState() {
    super.initState();
    setUp();
  }

  editPembayaran() async {
    final response = await http.post(BaseUrl.editPembayaran, body: {
      "pembayaran": pembayaran,
      "keterangan": keterangan,
      "idData": widget.bayar.id
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['pesan'];
    if (value == 1) {
      setState(() {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return MenuHutang();
        }));
      });
    } else {
      print(pesan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Edit Data Pembayaran"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return MenuHutang();
              }));
            }),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: Column(children: <Widget>[
            TextFormField(
              controller: txtPembayaran,
              onSaved: (e) => pembayaran = e,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.attach_money),
                  prefixText: "Rp. ",
                  prefixStyle: TextStyle(color: Colors.black, fontSize: 16.0),
                  labelText: "Pembayaran",
                  hintText: "Jumlah Pembayaran",
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
