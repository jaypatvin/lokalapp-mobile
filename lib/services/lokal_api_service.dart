import 'dart:convert';
import 'package:http/http.dart' as http;

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
