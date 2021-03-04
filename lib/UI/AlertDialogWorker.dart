import 'package:flutter/material.dart';
import 'package:summ_flutter_app/CurrentUser.dart';
import '../entity/Summ/Summ.dart';
import 'package:summ_flutter_app/UI/ToastManager.dart';
import 'package:summ_flutter_app/network/Networker.dart';
import 'package:summ_flutter_app/worker/DateWorker.dart';

class AlertDialogWorker {
  static String ipText = "";
  static TextEditingController ipEdController = new TextEditingController();

  static Future showIpSettingsDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Configuring server IP'),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                height: 60,
                padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: new Expanded(
                    child: new TextField(
                  controller: ipEdController,
                  autofocus: true,
                  decoration: new InputDecoration(hintText: '192.168.x.x'),
                  onChanged: (value) {
                    ipText = value;
                  },
                )),
              ),
            ],
          ),
          actions: [
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Confirm'),
              onPressed: () {
                Networker.instance.changeIP(ipEdController.text);
                ToastManager().showSuccessDialog("changed to ${Networker.instance.baseUrl}");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future showFullSummDialog(BuildContext context, Summ summ) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(summ.title,style: TextStyle(fontSize: 32),),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Description: ${summ.descript}",style: TextStyle(fontWeight: FontWeight.w700),),
              Text("Speciality: ${summ.number}",style: TextStyle(fontWeight: FontWeight.w700),),
              SizedBox(height: 16),
              Text(summ.text)
            ],
          ),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future showProfileSettingsDialog(BuildContext context) {
    String name = "";
    String password = "";
    TextEditingController nameTFController = new TextEditingController();
    TextEditingController passwordTFController = new TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: true,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Profile settings",style: TextStyle(fontSize: 32),),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Current username:${CurrentUser.user.username}",style: TextStyle(fontWeight: FontWeight.w700),),
              new Expanded(
                  child: new TextField(
                    controller: nameTFController,
                    autofocus: true,
                    decoration: new InputDecoration(hintText: 'Name'),
                    onChanged: (value) {
                      name = value;
                    },
                  )),
              SizedBox(height: 16),
              Text("Current password: ${CurrentUser.user.password}",style: TextStyle(fontWeight: FontWeight.w700),),
              Expanded(
                  child: new TextField(
                    controller: passwordTFController,
                    decoration: new InputDecoration(hintText: 'Password'),
                    onChanged: (value) {
                      password = value;
                    },
                  )),
              SizedBox(height: 16),
            ],
          ),
          actions: [
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Apply'),
              onPressed: () {
                CurrentUser.user.username = name;
                CurrentUser.user.password = password;
                CurrentUser.user.dateReg = Date().convertToDate(CurrentUser.user.dateReg);
                CurrentUser.user.dateLastSeen = Date().convertToDate(CurrentUser.user.dateLastSeen);

                Networker.instance.updateUser(CurrentUser.user);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
