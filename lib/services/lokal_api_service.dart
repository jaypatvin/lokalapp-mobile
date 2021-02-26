import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lokalapp/models/user_shop_post.dart';
import 'package:lokalapp/services/database.dart';
import 'package:lokalapp/states/current_user.dart';
import 'package:provider/provider.dart';
import 'package:cloud_functions/cloud_functions.dart';

class LokalApiService {
  static const _baseUrl =
      'https://us-central1-lokal-1baac.cloudfunctions.net/api/v1';

  Future<http.Response> createUser(Map data) async {
    var body = json.encode(data);
    return await http.post(
      "$_baseUrl/users",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
  }

  // uses user doc id
  Future<http.Response> getUserData(String id) async {
    if (id.isEmpty) http.Response("", 204);
    return await http.get("$_baseUrl/users/$id");
  }

  Future<http.Response> updateUserData(Map data) async {
    String body = json.encode(data);
    return await http.put(
      "$_baseUrl/users/${data["id"]}",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
  }

  Future<http.Response> deleteUser(String id) async {
    final request =
        http.Request('DELETE', Uri.parse('$_baseUrl/shops/getUserShops'))
          ..headers.addAll({'content-type': 'application/json; charset=utf-8'})
          ..body = json.encode({'id': id});
    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> checkInviteCode(String inviteCode) async {
    return await http.get("$_baseUrl/invite/check/$inviteCode");
  }

  Future<http.Response> claimInviteCode(
      String userUid, String inviteCode) async {
    String body = json.encode(
      {
        "user_id": userUid,
        "code": inviteCode,
      },
    );
    return await http.post(
      "$_baseUrl/invite/claim",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
  }

  Future<String> createStore(Map data) async {
    var body = json.encode(data);
    var response = await http.post(
      "$_baseUrl/shops",
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    return response.body;
  }

  // Future getShopById(String uid) async {
  //   final response = await http.get('$_baseUrl/:$uid/shops');
  //   if (response.statusCode == 200) {
  //     return response.body;
  //   } else {
  //     throw Exception('Failed to load shop');
  //   }
  // }
  Future getShopByUserId(String uid) async {
    final request =
        http.Request('GET', Uri.parse('$_baseUrl/users/:$uid/shops'));
    request.headers.addAll({'content-type': 'application/json; charset=utf-8'});
    request.body = json.encode({'user_id': uid});
    // return request.body;
    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<String> updateStore(Map data, String uid) async {
    var body = json.encode(data);
    http.Response response = await http.put(
      '$_baseUrl/users/:$uid/shops',
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    return response.body;
  }

  Future<http.Response> getAllComunities() async {
    return await http.get("$_baseUrl/community");
  }

  Future<http.Response> getCommunity(String id) async {
    if (id.isEmpty) http.Response("", 204);
    return await http.get("$_baseUrl/community/$id");
  }

  Future<http.Response> updateCommunity(Map data) async {
    String body = json.encode(data);
    return await http.put(
      "$_baseUrl/community/${data["id"]}",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
  }

  Future<http.Response> getUsersByCommunity(String id) async {
    return await http.get("$_baseUrl/community/$id/users");
  }

  Future<http.Response> getShopsByCommunity(String id) async {
    return await http.get("$_baseUrl/community/$id/shops");
  }

  Future<http.Response> getProductsByCommunity(String id) async {
    return await http.get("$_baseUrl/community/$id/products");

  }
}
