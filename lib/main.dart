import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'contactModel.dart';

void main() {
  runApp(MaterialApp(
    title: 'Belajar ListView',
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int value = 2;
  final list = new List<ContactModel>();

  _addItem() {
    setState(() {
      value = value + 1;
    });
  }

  Future<void> _lihatData() async {
    final response = await http.get("http://188.166.177.2/flutter/list.php");
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final mapJson = map["data"];
      //print(mapJson[2]);
      mapJson.forEach((x) {
        final contact = new ContactModel(x['id'], x['nama'], x['hp']);
        list.add(contact);
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
      appBar: AppBar(
        title: Text("Daftar Kontak"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                this._lihatData();
              });
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final dataList = list[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(dataList.id),
            ),
            title: Text(
              dataList.nama,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(dataList.hp),
          );
        },
      ),
    );
  }
}
