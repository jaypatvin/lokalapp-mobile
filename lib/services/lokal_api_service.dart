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
}
