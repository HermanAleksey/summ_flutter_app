import 'dart:convert';

List<Summ> summFromJson(String str) => List<Summ>.from(json.decode(str).map((x) => Summ.fromJson(x)));

String summToJson(List<Summ> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Summ {
  Summ({
    this.id,
    this.title,
    this.descript,
    this.number,
    this.text,
    this.filename,
    this.dateRegistr,
  });

  int id;
  String title;
  String descript;
  String number;
  String text;
  dynamic filename;
  String dateRegistr;

  factory Summ.fromJson(Map<String, dynamic> json) => Summ(
    id: json["id"],
    title: json["title"],
    descript: json["descript"],
    number: json["number"],
    text: json["text"],
    filename: json["filename"],
    dateRegistr: json["dateRegistr"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "descript": descript,
    "number": number,
    "text": text,
    "filename": filename,
    "dateRegistr": dateRegistr,
  };
}