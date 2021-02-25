import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LokalApiService {
  static const _baseUrl =
      'https://us-central1-lokal-1baac.cloudfunctions.net/api/v1';

  Future<http.Response> createUser({@required Map data, String idToken}) async {
    var body = json.encode(data);
    return await http.post(
      "$_baseUrl/users",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );
  }

  // uses user doc id
  Future<http.Response> getUserData(
      {@required String id, String idToken}) async {
    if (id.isEmpty) http.Response("", 204);
    return await http.get("$_baseUrl/users/$id",
        headers: {"Authorization": "Bearer $idToken"});
  }

  Future<http.Response> updateUserData(
      {@required Map data, String idToken}) async {
    String body = json.encode(data);
    return await http.put(
      "$_baseUrl/users/${data["id"]}",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );
  }

  Future<http.Response> deleteUser(
      {@required String id, String idToken}) async {
    final request =
        http.Request('DELETE', Uri.parse('$_baseUrl/shops/getUserShops'))
          ..headers.addAll({
            "content-type": "application/json; charset=utf-8",
            "Authorization": "Bearer $idToken"
          })
          ..body = json.encode({'id': id});
    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> checkInviteCode(
      {@required String code, String idToken}) async {
    return await http.get("$_baseUrl/invite/check/$code");
  }

  Future<http.Response> claimInviteCode({
    @required String id,
    @required String code,
    String authToken,
  }) async {
    String body = json.encode(
      {
        "user_id": id,
        "code": code,
      },
    );
    return await http.post(
      "$_baseUrl/invite/claim",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $authToken"
      },
      body: body,
    );
  }

  Future<String> createStore({@required Map data, String idToken}) async {
    var body = json.encode(data);
    var response = await http.post(
      "$_baseUrl/shops",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );

    return response.body;
  }

  Future<http.Response> getAllComunities({String idToken}) async {
    return await http.get("$_baseUrl/community",
        headers: {"Authorization": "Bearer $idToken"});
  }

  Future<http.Response> getCommunity(
      {@required String id, String idToken}) async {
    if (id.isEmpty) http.Response("", 204);
    return await http.get("$_baseUrl/community/$id",
        headers: {"Authorization": "Bearer $idToken"});
  }

  Future<http.Response> updateCommunity(
      {@required Map data, String idToken}) async {
    String body = json.encode(data);
    return await http.put(
      "$_baseUrl/community/${data["id"]}",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );
  }

  Future<http.Response> getUsersByCommunity(
      {@required String id, String idToken}) async {
    return await http.get("$_baseUrl/community/$id/users",
        headers: {"Authorization": "Bearer $idToken"});
  }

  Future<http.Response> getShopsByCommunity(
      {@required String id, String idToken}) async {
    return await http.get("$_baseUrl/community/$id/shops",
        headers: {"Authorization": "Bearer $idToken"});
  }

  Future<http.Response> getProductsByCommunity(
      {@required String id, String idToken}) async {
    return await http.get("$_baseUrl/community/$id/products",
        headers: {"Authorization": "Bearer $idToken"});
  }
}
