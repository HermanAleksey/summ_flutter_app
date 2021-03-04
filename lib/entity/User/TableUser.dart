import 'User.dart';

class TableUser{
  bool checked;
  User user;

  TableUser(this.checked,this.user);

  TableUser fromUser (User user){
    return TableUser(false, user);
  }

  @override
  String toString() {
    return 'TableUser{checked: $checked, user: $user}';
  }

  List<TableUser> convertList(List<User> list){
    List<TableUser> tableUserList = new List();
    list.forEach((element) {
      TableUser tableUser = new TableUser(false,element);
      tableUserList.add(tableUser);
    });
    return tableUserList;
  }
}