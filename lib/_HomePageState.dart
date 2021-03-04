import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:summ_flutter_app/CurrentUser.dart';
import 'package:summ_flutter_app/UI/AlertDialogWorker.dart';
import 'package:summ_flutter_app/network/Networker.dart';

import 'UI/NavigationDrawerWorker.dart';
import 'entity/Role.dart';
import 'entity/Summ/Summ.dart';
import 'network/Networker.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MyHomePage> {
  List<Summ> items = new List<Summ>();

  @override
  void initState() {
    super.initState();
    fetchData();
    updateNavDraw();
  }

  void fetchData() async {
    final response = await Networker.instance.getAllSumms();
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      setState(() {
        items = summFromJson(response.body);
      });
    }
  }

  Drawer _navigationDrawer = Drawer();
  void updateNavDraw(){
      _navigationDrawer = NavigationDrawer().getNavDrawer(
          context, CurrentUser.user.getRole());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _navigationDrawer,
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  fetchData();
                },
                child: Icon(
                  Icons.refresh,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: ListView(
          padding: const EdgeInsets.all(8),
          scrollDirection: Axis.vertical,
          children: buildList()),
    );
  }

  List<Widget> buildList() {
    List<Widget> list = new List<Widget>();
    list.add(Text("Hello, guest!",
        style: TextStyle(
          fontSize: 32,
        )));
    list.add(SizedBox(
      height: 16,
    ));
    list.add(Text(
        "On this page you have the opportunity to familiarize yourself"
            " with the abstracts of lectures on various academic subjects."
            " You can also find a lot of useful and necessary material for yourself. Forward!",
        style: TextStyle(
          fontSize: 16,
        )));
    list.add(SizedBox(
      height: 16,
    ));
    items.forEach((element) {
      list.add(
        Card(
          child: ListTile(
            leading: FlutterLogo(size: 36.0),
            title: Text(element.title),
            subtitle: Text(element.descript),
            isThreeLine: true,
            onTap: () {
              //открытие полного описания заметки в диалоговом окне
              AlertDialogWorker.showFullSummDialog(context, element);
            },
          ),
        ),
      );
    });

    return list;
  }
}
