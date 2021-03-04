import 'dart:convert';

import 'package:flutter/material.dart';
import 'file:///D:/pROJECTS/Flutter/summ_flutter_app/summ_flutter_app/lib/worker/DateWorker.dart';
import 'package:summ_flutter_app/entity/User/User.dart';

import 'CurrentUser.dart';
import 'UI/NavigationDrawerWorker.dart';
import 'entity/User/TableUser.dart';
import 'network/Networker.dart';

class MyUsersTablePage extends StatefulWidget {
  MyUsersTablePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _UsersTablePageState createState() => _UsersTablePageState();
}

class _UsersTablePageState extends State<MyUsersTablePage> {
  bool sort = true;
  bool sortId = true;
  bool sortName = true;
  bool sortPassword = true;
  bool sortDateReg = true;
  bool sortDateLastSeen = true;
  int sortColIndex = 0;

  List<User> userList = new List();
  List<TableUser> tableUserList = new List();

  @override
  void initState() {
    super.initState();
    fetchData();
    updateNavDraw();
  }

  void fetchData() async {
    final response = await Networker.instance.getAllUsers();
    if (response.statusCode == 200) {
      userList = userFromJson(response.body);
      tableUserList = TableUser(false, new User()).convertList(userList);
      setState(() {});
    }
  }

  Drawer _navigationDrawer = Drawer();

  void updateNavDraw() {
    _navigationDrawer =
        NavigationDrawer().getNavDrawer(context, CurrentUser.user.getRole());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _navigationDrawer,
      appBar: AppBar(
        title: Text("Users list"),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  //refresh
                  fetchData();
                },
                child: Icon(
                  Icons.refresh,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  //selecting checked items
                  List<int> checkedList = new List();
                  tableUserList.forEach((element) {
                    if (element.checked) {
                      checkedList.add(element.user.id);
                    }
                  });
                  //delete dialog
                  _asyncShowUserDeleteDialog(context, checkedList);
                },
                child: Icon(
                  Icons.delete,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  //block/unblock
                  //selecting checked items
                  List<int> checkedList = new List();
                  tableUserList.forEach((element) {
                    if (element.checked) {
                      checkedList.add(element.user.id);
                    }
                  });
                  //block dialog
                  _asyncShowUserBlockDialog(context, checkedList);
                },
                child: Icon(
                  Icons.block,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            sortAscending: sort,
            sortColumnIndex: sortColIndex,
            columns: [
              DataColumn(
                  label: Center(child: Text('ID')),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      sortId = !sortId;
                      sort = sortId;
                      sortColIndex = 0;
                    });
                    onSortColumn(0, sortId);
                  }),
              DataColumn(
                  label: Center(child: Text('Name')),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      sortName = !sortName;
                      sort = sortName;
                      sortColIndex = 1;
                    });
                    onSortColumn(1, sortName);
                  }),
              DataColumn(
                  label: Center(child: Text('Name')),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      sortPassword = !sortPassword;
                      sort = sortPassword;
                      sortColIndex = 2;
                    });
                    onSortColumn(2, sortPassword);
                  }),
              DataColumn(
                label: Center(child: Text('Role')),
              ),
              DataColumn(
                  label: Center(child: Text('Date reg')),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      sortDateReg = !sortDateReg;
                      sort = sortDateReg;
                      sortColIndex = 3;
                    });
                    onSortColumn(3, sortDateReg);
                  }),
              DataColumn(
                  label: Center(child: Text('Date last seen')),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      sortDateLastSeen = !sortDateLastSeen;
                      sort = sortDateLastSeen;
                      sortColIndex = 4;
                    });
                    onSortColumn(4, sortDateLastSeen);
                  }),
              DataColumn(
                label: Center(child: Text('Active')),
              ),
              DataColumn(
                label: Center(child: Text('Edit')),
              ),
            ],
            rows: getUsersListWidget(),
          ),
        ),
      ),
    );
  }

  onSortColumn(int columnIndex, bool ascending) {
    switch (columnIndex) {
      case 0:
        {
          if (ascending) {
            tableUserList.sort((a, b) => a.user.id.compareTo(b.user.id));
          } else {
            tableUserList.sort((a, b) => b.user.id.compareTo(a.user.id));
          }
          break;
        }
      case 1:
        {
          if (ascending) {
            tableUserList
                .sort((a, b) => a.user.username.compareTo(b.user.username));
          } else {
            tableUserList
                .sort((a, b) => b.user.username.compareTo(a.user.username));
          }
          break;
        }
      case 2:
        {
          if (ascending) {
            tableUserList
                .sort((a, b) => a.user.password.compareTo(b.user.password));
          } else {
            tableUserList
                .sort((a, b) => b.user.password.compareTo(a.user.password));
          }
          break;
        }
      case 3:
        {
          if (ascending) {
            tableUserList
                .sort((a, b) => a.user.dateReg.compareTo(b.user.dateReg));
          } else {
            tableUserList
                .sort((a, b) => b.user.dateReg.compareTo(a.user.dateReg));
          }
          break;
        }
      case 4:
        {
          if (ascending) {
            tableUserList.sort(
                    (a, b) =>
                    a.user.dateLastSeen.compareTo(b.user.dateLastSeen));
          } else {
            tableUserList.sort(
                    (a, b) =>
                    b.user.dateLastSeen.compareTo(a.user.dateLastSeen));
          }
          break;
        }
    }
  }

  List<DataRow> getUsersListWidget() {
    List<DataRow> list = new List();

    for (int i = 0; i < tableUserList.length; i++) {
      list.add(DataRow(
        cells: [
          DataCell(Text('${tableUserList[i].user.id}')),
          DataCell(Text('${tableUserList[i].user.username}')),
          DataCell(Text('${tableUserList[i].user.password}')),
          DataCell(Text('${tableUserList[i].user.getRole()}')),
          DataCell(Text('${tableUserList[i].user.dateReg}')),
          DataCell(Text('${tableUserList[i].user.dateLastSeen}')),
          DataCell(Text('${tableUserList[i].user.active}')),
          DataCell(IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              /**---------------------------editing element dialog + sending request to update------------------------------**/
              _asyncShowUserUpdateDialog(context, tableUserList[i].user);
            },
          )),
        ],
        selected: tableUserList[i].checked,
        onSelectChanged: (bool value) {
          setState(() {
            tableUserList[i].checked = !tableUserList[i].checked;
          });
        },
      ));
    }
    return list;
  }

  /// ---------------------------               Диалог редактирования обьекта         ----------------------------**/
  Future _asyncShowUserUpdateDialog(BuildContext context, User user) {
    String name = "";
    String password = "";
    TextEditingController nameTFController = new TextEditingController();
    TextEditingController passwordTFController = new TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "User #${user.id}",
            style: TextStyle(fontSize: 32),
          ),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              new Expanded(
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
              child: Text('Update'),
              onPressed: () {
                user.username = name;
                user.password = password;
                user.dateReg = Date().convertToDate(user.dateReg);
                user.dateLastSeen = Date().convertToDate(user.dateLastSeen);
                setState(() {});
                Networker.instance.updateUser(user);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// ---------------------------               Диалог удаления юзера         ----------------------------**/
  Future _asyncShowUserDeleteDialog(BuildContext context, List<int> numbers) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Removing",
            style: TextStyle(fontSize: 32),
          ),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are u sure u want to remove users with id's:${numbers}",
                style: TextStyle(fontSize: 18),
              ),
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
              child: Text('Remove'),
              onPressed: () {
                //запрос на удалени
                Networker.instance.removeUsers(numbers);

                fetchData();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// ---------------------------          Диалог блокировки юзера         ----------------------------**/
  Future _asyncShowUserBlockDialog(BuildContext context, List<int> numbers) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Removing",
            style: TextStyle(fontSize: 32),
          ),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are u sure u want to block users with id's:${numbers}",
                style: TextStyle(fontSize: 18),
              ),
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
              child: Text('Block'),
              onPressed: () {
                Networker.instance.blockUsers(numbers);
                //применяем без обновления всех данных
                tableUserList.forEach((element) {
                  if (numbers.contains(element)){
                    element.user.active = !element.user.active;
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
