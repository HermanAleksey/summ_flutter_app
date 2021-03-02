import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:summ_flutter_app/CurrentUser.dart';
import 'package:summ_flutter_app/entity/Role.dart';
import 'package:summ_flutter_app/network/Networker.dart';
import 'package:http/http.dart';

import 'package:summ_flutter_app/UI/ToastManager.dart';

import 'entity/User.dart';

class MyLoginPage extends StatefulWidget {
  MyLoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<MyLoginPage> {
  var _obscureTextPassword = true;

  void _passwordIconClick() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  TextEditingController urlInputController = new TextEditingController();
  TextEditingController loginInputController = new TextEditingController();
  String loginValue;
  TextEditingController passwordInputController = new TextEditingController();
  String passwordValue;

  void updateValues() {
    loginValue = loginInputController.text;
    passwordValue = passwordInputController.text;
  }

  Future<void> sendLoginRequest(String login, String password) async {
    if (login.isEmpty || password.isEmpty) return;
    Response response = await Networker.instance.singIn(login, password);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    print("statusCode = $statusCode; response = $responseBody");

    if (statusCode == 200) {
      //if OK - log in.
      User user = User.fromJson(jsonDecode(responseBody));

      //saving user info
      CurrentUser.user = user;
      ToastManager().showSuccessDialog("Logged IN!");
      Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
    } else {
      ToastManager().showErrorDialog("No such user!");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sing in"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(30.0, 150.0, 30.0, 20.0),
          child: Column(
            children: [
              TextField(
                controller: loginInputController,
                decoration: InputDecoration(
                    labelText: "Login",
                    hintText: "Input your login",
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 16,
              ),
              Form(
                child: TextFormField(
                  controller: passwordInputController,
                  validator: (String value) {
                    if (value.length < 4) {
                      return "Password is too short";
                    } else
                      return null;
                  },
                  decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Input your password",
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureTextPassword
                            ? Icons.remove_red_eye
                            : Icons.security),
                        onPressed: () {
                          _passwordIconClick();
                        },
                      )),
                  obscureText: _obscureTextPassword,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(70.0, 16.0, 70.0, 16.0),
                  elevation: 5.0,
                  child: Text("Login"),
                  splashColor: Colors.white12,
                  //цвет отпускания клавиши
                  onPressed: () async {
                    /**-----------Запрос на вход ---------**/
                    updateValues();
                    sendLoginRequest(loginValue,passwordValue);
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
