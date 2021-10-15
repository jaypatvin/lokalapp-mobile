import 'dart:convert';

import 'package:http/http.dart' as http;

import 'lokal_api_constants.dart';

class UsersService {
  static UsersService? _instance;
  static UsersService? get instance {
    if (_instance == null) {
      _instance = UsersService();
    }
    return _instance;
  }

  // --POST
  Future<http.Response> create(
      {required Map data, required String? idToken}) async {
    var body = json.encode(data);
    return await http.post(
      Uri.parse(usersUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );
  }

  // --GET
  Future<http.Response> getById(
      {required String userId, required String? idToken}) async {
    if (userId.isEmpty) http.Response("", 204);
    return await http.get(
      Uri.parse("$usersUrl/$userId"),
      headers: {"Authorization": "Bearer $idToken"},
    );
  }

  Future<http.Response> getCommunityUsers(
      {required String? communityId, required String? idToken}) async {
    return await http.get(
      Uri.parse("$communityUrl/$communityId/users"),
      headers: {"Authorization": "Bearer $idToken"},
    );
  }

  // --PUT
  Future<http.Response> update(
      {required Map data, required String? idToken}) async {
    String body = json.encode(data);
    return await http.put(
      Uri.parse("$usersUrl/${data["id"]}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );
  }

  // --DELETE
  Future<http.Response> delete(
      {required String userId, required String idToken}) async {
    return await http.delete(
      Uri.parse("$usersUrl/$userId"),
      headers: {"Authorization": "Bearer $idToken"},
    );
  }
}
