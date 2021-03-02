import 'package:flutter/material.dart';
import 'package:summ_flutter_app/entity/Summ.dart';
import 'package:summ_flutter_app/UI/ToastManager.dart';
import 'package:summ_flutter_app/network/Networker.dart';

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
}
