class Date {

  convertToDate(String string){
    String yyyyMMdd = string.split(' ')[0];
    List<String> list = yyyyMMdd.split('-');
    String day = list[0];
    String month = list[1];
    String year = list[2];

    return "$year-$month-$day";
  }

}