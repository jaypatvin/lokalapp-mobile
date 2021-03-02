import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LokalApiService {
  static const _baseUrl =
      'https://us-central1-lokal-1baac.cloudfunctions.net/api/v1';

  Future<http.Response> createUser(
      {@required Map data, @required String idToken}) async {
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
      {@required String userId, @required String idToken}) async {
    if (userId.isEmpty) http.Response("", 204);
    return await http.get("$_baseUrl/users/$userId",
        headers: {"Authorization": "Bearer $idToken"});
  }

  Future<http.Response> updateUserData(
      {@required Map data, @required String idToken}) async {
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
      {@required String userId, @required String idToken}) async {
    final request =
        http.Request('DELETE', Uri.parse('$_baseUrl/shops/getUserShops'))
          ..headers.addAll({
            "content-type": "application/json; charset=utf-8",
            "Authorization": "Bearer $idToken"
          })
          ..body = json.encode({'id': userId});
    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> checkInviteCode(
      {@required String code, @required String idToken}) async {
    return await http.get("$_baseUrl/invite/check/$code",
        headers: {"Authorization": "Bearer $idToken"});
  }

  Future<http.Response> claimInviteCode({
    @required String userId,
    @required String code,
    @required String email,
    @required String idToken,
  }) async {
    String body = json.encode(
      {
        "user_id": userId,
        "code": code,
      },
    );
    return await http.post(
      "$_baseUrl/invite/claim",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );
  }

  Future<http.Response> createStore(
      {@required Map data, @required String idToken}) async {
    var body = json.encode(data);
    var response = await http.post(
      "$_baseUrl/shops",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );

    return response;
  }

  Future<http.Response> getShopByUserId(
      {@required String userId, @required String idToken}) async {
    return await http.get("$_baseUrl/users/$userId/shops",
        headers: {"Authorization": "Bearer $idToken"});
  }

  Future<http.Response> updateStore(
      {@required Map data, @required String idToken}) async {
    var body = json.encode(data);
    http.Response response = await http.put(
      "$_baseUrl/shops/${data['id']}",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );

    return response;
  }

  Future<http.Response> getAllComunities({@required String idToken}) async {
    return await http.get("$_baseUrl/community",
        headers: {"Authorization": "Bearer $idToken"});
  }

  Future<http.Response> getCommunity(
      {@required String communityId, @required String idToken}) async {
    if (communityId.isEmpty) http.Response("", 204);
    return await http.get("$_baseUrl/community/$communityId",
        headers: {"Authorization": "Bearer $idToken"});
  }

  Future<http.Response> updateCommunity(
      {@required Map data, @required String idToken}) async {
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
      {@required String communityId, @required String idToken}) async {
    return await http.get("$_baseUrl/community/$communityId/users",
        headers: {"Authorization": "Bearer $idToken"});
  }

  Future<http.Response> getShopsByCommunity(
      {@required String communityId, @required String idToken}) async {
    return await http.get("$_baseUrl/community/$communityId/shops",
        headers: {"Authorization": "Bearer $idToken"});
  }

  Future<http.Response> getProductsByCommunity(
      {@required String communityId, @required String idToken}) async {
    return await http.get("$_baseUrl/community/$communityId/products",
        headers: {"Authorization": "Bearer $idToken"});
  }
}
