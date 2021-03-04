import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:summ_flutter_app/UI/AlertDialogWorker.dart';
import 'entity/Summ/Summ.dart';
import 'entity/Summ/TableSumm.dart';
import 'worker/DateWorker.dart';

import 'CurrentUser.dart';
import 'UI/NavigationDrawerWorker.dart';
import 'network/Networker.dart';

class MyCabinetPage extends StatefulWidget {
  MyCabinetPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CabinetPageState createState() => _CabinetPageState();
}

class _CabinetPageState extends State<MyCabinetPage> {
  bool sort = true;
  bool sortId = true;
  bool sortTitle = true;
  bool sortDescription = true;
  bool sortNumber = true;
  bool sortDateReg = true;
  int sortColIndex = 0;

  List<Summ> summList = new List();
  List<TableSumm> tableSummsList = new List();

  @override
  void initState() {
    super.initState();
    fetchData();
    updateNavDraw();
  }

  void fetchData() async {
    final response =
        await Networker.instance.getSummsForUser(CurrentUser.user.id);
    if (response.statusCode == 200) {
      summList = summFromJson(response.body);
      tableSummsList = TableSumm(false, new Summ()).convertList(summList);
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.plus_one_rounded),
        onPressed: () async {
          await _asyncShowInputSummDialog(context);
        },
      ),
      appBar: AppBar(
        title: Text("Cabinet"),
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
                  tableSummsList.forEach((element) {
                    if (element.checked) {
                      checkedList.add(element.summ.id);
                    }
                  });
                  //delete dialog
                  _asyncShowSummsDeleteDialog(context, checkedList);
                },
                child: Icon(
                  Icons.delete,
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
                  label: Center(child: Text('Title')),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      sortTitle = !sortTitle;
                      sort = sortTitle;
                      sortColIndex = 1;
                    });
                    onSortColumn(1, sortTitle);
                  }),
              DataColumn(
                  label: Center(child: Text('Description')),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      sortDescription = !sortDescription;
                      sort = sortDescription;
                      sortColIndex = 2;
                    });
                    onSortColumn(2, sortDescription);
                  }),
              DataColumn(
                  label: Center(child: Text('Number')),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      sortNumber = !sortNumber;
                      sort = sortNumber;
                      sortColIndex = 3;
                    });
                    onSortColumn(3, sortNumber);
                  }),
              DataColumn(
                  label: Center(child: Text('Date reg')),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      sortDateReg = !sortDateReg;
                      sort = sortDateReg;
                      sortColIndex = 4;
                    });
                    onSortColumn(4, sortDateReg);
                  }),
              // DataColumn(
              //   label: Center(child: Text("")),
              // )
            ],
            rows: getSummsListWidget(),
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
            tableSummsList.sort((a, b) => a.summ.id.compareTo(b.summ.id));
          } else {
            tableSummsList.sort((a, b) => b.summ.id.compareTo(a.summ.id));
          }
          break;
        }
      case 1:
        {
          if (ascending) {
            tableSummsList.sort((a, b) => a.summ.title.compareTo(b.summ.title));
          } else {
            tableSummsList.sort((a, b) => b.summ.title.compareTo(a.summ.title));
          }
          break;
        }
      case 2:
        {
          if (ascending) {
            tableSummsList
                .sort((a, b) => a.summ.descript.compareTo(b.summ.descript));
          } else {
            tableSummsList
                .sort((a, b) => b.summ.descript.compareTo(a.summ.descript));
          }
          break;
        }
      case 3:
        {
          if (ascending) {
            tableSummsList
                .sort((a, b) => a.summ.number.compareTo(b.summ.number));
          } else {
            tableSummsList
                .sort((a, b) => b.summ.number.compareTo(a.summ.number));
          }
          break;
        }
      case 4:
        {
          if (ascending) {
            tableSummsList.sort(
                (a, b) => a.summ.dateRegistr.compareTo(b.summ.dateRegistr));
          } else {
            tableSummsList.sort(
                (a, b) => b.summ.dateRegistr.compareTo(a.summ.dateRegistr));
          }
          break;
        }
    }
  }

  List<DataRow> getSummsListWidget() {
    List<DataRow> list = new List();

    for (int i = 0; i < tableSummsList.length; i++) {
      list.add(DataRow(
        cells: [
          DataCell(Text('${tableSummsList[i].summ.id}')),
          DataCell(FlatButton(
              onPressed: () {
                AlertDialogWorker.showFullSummDialog(
                    context, tableSummsList[i].summ);
              },
              child: Text('${tableSummsList[i].summ.title}'))),
          DataCell(Text('${tableSummsList[i].summ.descript}')),
          DataCell(Text('${tableSummsList[i].summ.number}')),
          DataCell(Text('${tableSummsList[i].summ.dateRegistr}')),
          // DataCell(IconButton(
          //   icon: Icon(Icons.edit),
          //   onPressed: () {
          //     /**---------------------------editing element dialog + sending request to update------------------------------**/
          //     // _asyncShowUserUpdateDialog(context, tableUserList[i].user);
          //   },
          // )),
        ],
        selected: tableSummsList[i].checked,
        onSelectChanged: (bool value) {
          setState(() {
            tableSummsList[i].checked = !tableSummsList[i].checked;
          });
        },
      ));
    }
    return list;
  }

  /// ---------------------------               Диалог добавления обьекта         ----------------------------**/
  Future _asyncShowInputSummDialog(BuildContext context) {
    String title = "";
    String description = "";
    String number = "";
    String text = "";
    TextEditingController titleTFController = new TextEditingController();
    TextEditingController descriptionTFController = new TextEditingController();
    TextEditingController numberTFController = new TextEditingController();
    TextEditingController textTFController = new TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Insert dialog",
            style: TextStyle(fontSize: 32),
          ),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              new Expanded(
                  child: new TextField(
                controller: titleTFController,
                autofocus: true,
                decoration: new InputDecoration(hintText: 'Title'),
                onChanged: (value) {
                  title = value;
                },
              )),
              SizedBox(height: 16),
              new Expanded(
                  child: new TextField(
                controller: descriptionTFController,
                decoration: new InputDecoration(hintText: 'Descriptoin'),
                onChanged: (value) {
                  description = value;
                },
              )),
              SizedBox(height: 16),
              new Expanded(
                  child: new TextField(
                controller: numberTFController,
                decoration: new InputDecoration(hintText: 'Number'),
                onChanged: (value) {
                  number = value;
                },
              )),
              SizedBox(height: 16),
              new Expanded(
                  child: new TextField(
                controller: textTFController,
                decoration: new InputDecoration(hintText: 'Text'),
                onChanged: (value) {
                  text = value;
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
              child: Text('Create'),
              onPressed: () {
                Summ summ = new Summ();
                summ.title = title;
                summ.descript = description;
                summ.number = number;
                summ.text = text;
                setState(() {});
                Networker.instance.insertSumm(CurrentUser.user.id, summ);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// ---------------------------               Диалог удаления summ         ----------------------------**/
  Future _asyncShowSummsDeleteDialog(BuildContext context, List<int> numbers) {
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
                "Are u sure u want to remove summs with id's:${numbers}",
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
                Networker.instance.removeSumms(numbers);

                fetchData();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
