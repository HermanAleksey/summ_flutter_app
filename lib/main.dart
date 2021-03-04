import 'package:flutter/material.dart';
import 'package:summ_flutter_app/_CabinetPageState.dart';
import 'package:summ_flutter_app/_HomePageState.dart';
import 'package:summ_flutter_app/_UsersTablePageState.dart';

import '_LoginPageState.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      // home: MyLoginPage(),
      routes: {
        '/': (BuildContext context) => MyHomePage(),
        '/login': (BuildContext context) => MyLoginPage(),
        '/registration': (BuildContext context) => MyHomePage(),
        '/userTable': (BuildContext context) => MyUsersTablePage(),
        '/cabinet': (BuildContext context) => MyCabinetPage(),
      },
    );
  }
}
