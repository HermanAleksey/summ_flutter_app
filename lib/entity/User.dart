// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'Role.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.username,
    this.password,
    this.active,
    this.email,
    this.roles,
    this.dateReg,
    this.dateLastSeen,
  });

  int id;
  String username;
  String password;
  bool active;
  String email;
  List<String> roles;
  String dateReg;
  String dateLastSeen;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    password: json["password"],
    active: json["active"],
    email: json["email"],
    roles: List<String>.from(json["roles"].map((x) => x)),
    dateReg: json["dateReg"],
    dateLastSeen: json["dateLastSeen"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "password": password,
    "active": active,
    "email": email,
    "roles": List<dynamic>.from(roles.map((x) => x)),
    "dateReg": dateReg,
    "dateLastSeen": dateLastSeen,
  };

  Role getRole(){
    switch (roles[0]){
      case "ADMIN": return Role.ADMIN;
      case "USER": return Role.USER;
    }
    return Role.GUEST;
  }
}
