// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);
// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import '../Role.dart';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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

  void setRole(Role role) {
    roles.clear();
    roles.add(role.toString());
  }

  Role getRole() {
    switch (roles[0]) {
      case "ADMIN":
        return Role.ADMIN;
      case "USER":
        return Role.USER;
    }
    return Role.GUEST;
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username, password: $password, email: $email, dateReg: $dateReg, dateLastSeen: $dateLastSeen}';
  }

  User clone(User user) {
    return new User(
        id: user.id,
        username: user.username,
        password: user.password,
        active: user.active,
        email: user.email,
        roles: user.roles,
        dateReg: user.dateReg,
        dateLastSeen: user.dateLastSeen);
  }
}
