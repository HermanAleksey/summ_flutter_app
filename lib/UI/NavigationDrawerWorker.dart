import 'package:flutter/material.dart';
import 'package:summ_flutter_app/UI/AlertDialogWorker.dart';
import 'package:summ_flutter_app/entity/Role.dart';
import '../entity/User/User.dart';

import '../CurrentUser.dart';
import 'ToastManager.dart';

class NavigationDrawer {
  ListTile singInTile(BuildContext context) {
    return ListTile(
      title: Text("Sing in"),
      leading: Icon(Icons.login),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, '/login');
      },
    );
  }

  ListTile registrationTile(BuildContext context) {
    return ListTile(
      title: Text("Registration"),
      leading: Icon(Icons.app_registration),
      onTap: () {
        // Navigator.of(context).pop();
        // Navigator.pushNamed(context, '/reg');
      },
    );
  }

  ListTile ipSettingsTile(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.settings),
      title: Text('Settings'),
      onTap: () {
        AlertDialogWorker.showIpSettingsDialog(context);
      },
    );
  }

  ListTile homeTile(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.home),
      title: Text('Home'),
      onTap: () {
        //возврат к корню
        Navigator.of(context).pop();
        Navigator.pushNamed(context, '/home');
      },
    );
  }

  ListTile cabinetTile(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.work),
      title: Text('Cabinet'),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, '/cabinet');
      },
    );
  }

  ListTile profileTile(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.supervised_user_circle),
      title: Text('Profile'),
      onTap: () {
        AlertDialogWorker.showProfileSettingsDialog(context);
      },
    );
  }

  ListTile logOutTile(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.logout),
      title: Text('Sing out'),
      onTap: () {
        User user = CurrentUser.user;
        user.setRole(Role.GUEST);
        CurrentUser.user = user;
        ToastManager().showSuccessDialog("Logged out!");
        Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
      },
    );
  }

  ListTile userListTile(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.list),
      title: Text('User list'),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, '/userTable');
      },
    );
  }

  Drawer getNavDrawer(BuildContext context, Role role) {
    switch (role) {
      case Role.GUEST:
        {
          return Drawer(
            child: ListView(padding: EdgeInsets.zero, children: [
              DrawerHeader(
                child: Text("Header"),
              ),
              singInTile(context),
              registrationTile(context),
              Divider(),
              ipSettingsTile(context)
            ]),
          );
        }
      case Role.USER:
        {
          return Drawer(
            child: ListView(padding: EdgeInsets.zero, children: [
              DrawerHeader(
                child: Text("Header"),
              ),
              homeTile(context),
              cabinetTile(context),
              profileTile(context),
              Divider(),
              ipSettingsTile(context),
              logOutTile(context),
            ]),
          );
        }
      case Role.ADMIN:
        {
          return Drawer(
            child: ListView(padding: EdgeInsets.zero, children: [
              DrawerHeader(
                child: Text("Header"),
              ),
              userListTile(context),
              homeTile(context),
              cabinetTile(context),
              profileTile(context),
              Divider(),
              ipSettingsTile(context),
              logOutTile(context),
            ]),
          );
        }
    }
  }
}
