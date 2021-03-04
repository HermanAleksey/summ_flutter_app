import 'dart:convert';
import 'package:http/http.dart';
import '../entity/Summ/Summ.dart';
import 'package:summ_flutter_app/entity/User/User.dart';

//общая работа с API сервера. Организовано как синглтон.
class Networker {
  String baseUrl = 'http://192.168.100.8:8080/api/v1';
  final headers = {'Content-Type': 'application/json'};

  void changeIP(String serverIP) {
    baseUrl = "http://$serverIP:8080/api/v1";
  }

  Networker._privateConstructor();

  static final Networker _instance = Networker._privateConstructor();

  static Networker get instance => _instance;

  void requestDebug(String mapping, int responseCode, String responseBody) {
    print("\nWas called $mapping mapping\nresponse code = $responseCode\n"
        "response body = $responseBody\n---------------------\n");
  }

  Future<Response> getAllSumms() async {
    Response response = await get(baseUrl + "/home");
    requestDebug("/home", response.statusCode, response.body.toString());

    return response;
  }

  Future<Response> getSummsForUser(int userId) async {
    Response response = await get(baseUrl + "/user/summ?userId=$userId");
    requestDebug("/user/summ?userId=$userId", response.statusCode,
        response.body.toString());

    return response;
  }

  Future<Response> insertSumm(int userId, Summ summ) async {
    print("\n\n\ninsertSumm\n\n\n");
    Response response = await post(baseUrl + "/summ/insert?userId=$userId",
        headers: headers,
        body: jsonEncode(summ),
        encoding: Encoding.getByName("utf-8"));
    requestDebug("/summ/insert?userId=$userId", response.statusCode,
        response.body.toString());

    return response;
  }

  Future<bool> removeSumms(List<int> list) async {
    print("\n\n\n\nblablalbal\n\n\n\n");
    if (list.isEmpty) return false;
    print("\n\n\n\nblablalbal____2\n\n\n\n");

    Response response = await post(baseUrl + "/summ/deleteFew",
        headers: headers,
        body: list.toString(),
        encoding: Encoding.getByName("utf-8"));
    requestDebug(
        "/summ/deleteFew", response.statusCode, response.body.toString());

    if (response.statusCode != 200) return false;
    return true;
  }

  /***********************************************For users***********************************/

  Future<Response> singIn(String uname, String password) async {
    Response response =
        await get(baseUrl + "/login?uname=$uname&password=$password");
    requestDebug("/login?uname=$uname&password=$password", response.statusCode,
        response.body.toString());

    return response;
  }

  Future<Response> getAllUsers() async {
    Response response = await get(baseUrl + "/users");
    requestDebug("/users", response.statusCode, response.body.toString());

    return response;
  }

  Future<bool> updateUser(User user) async {
    print("\n\n\n$user\n\n\n");
    Response response = await post(baseUrl + "/user/update",
        headers: headers,
        body: jsonEncode(user),
        encoding: Encoding.getByName("utf-8"));

    requestDebug("/user/update", response.statusCode, response.body.toString());

    if (response.statusCode != 200) return false;
    return true;
  }

  Future<bool> removeUsers(List<int> list) async {
    if (list.isEmpty) return false;

    Response response = await post(baseUrl + "/user/deleteFew",
        headers: headers,
        body: list.toString(),
        encoding: Encoding.getByName("utf-8"));
    requestDebug(
        "/user/deleteFew", response.statusCode, response.body.toString());

    if (response.statusCode != 200) return false;
    return true;
  }

  Future<bool> blockUsers(List<int> list) async {
    if (list.isEmpty) return false;

    Response response = await post(baseUrl + "/user/blockFew",
        headers: headers,
        body: list.toString(),
        encoding: Encoding.getByName("utf-8"));
    requestDebug(
        "/user/blockFew", response.statusCode, response.body.toString());

    if (response.statusCode != 200) return false;
    return true;
  }
}
