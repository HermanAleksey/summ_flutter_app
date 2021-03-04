import 'Summ.dart';

class TableSumm{
  bool checked;
  Summ summ;

  TableSumm(this.checked,this.summ);

  TableSumm fromUser (Summ summ){
    return TableSumm(false, summ);
  }

  @override
  String toString() {
    return 'TableSumm{checked: $checked, user: $summ}';
  }

  List<TableSumm> convertList(List<Summ> list){
    List<TableSumm> tableUserList = new List();
    list.forEach((element) {
      TableSumm tableUser = new TableSumm(false,element);
      tableUserList.add(tableUser);
    });
    return tableUserList;
  }
}