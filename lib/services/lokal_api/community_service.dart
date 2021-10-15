import 'dart:convert';

import 'package:http/http.dart' as http;

import 'lokal_api_constants.dart';

class CommunityService {
  static CommunityService? _instance;
  static CommunityService? get instance {
    if (_instance == null) {
      _instance = CommunityService();
    }
    return _instance;
  }

  // --GET
  Future<http.Response> getAllComunities({required String idToken}) async {
    return await http.get(
      Uri.parse("$communityUrl"),
      headers: {"Authorization": "Bearer $idToken"},
    );
  }

  Future<http.Response> getCommunity(
      {required String communityId, required String idToken}) async {
    if (communityId.isEmpty) http.Response("", 204);
    return await http.get(
      Uri.parse("$communityUrl/$communityId"),
      headers: {"Authorization": "Bearer $idToken"},
    );
  }

  // --POST
  Future<http.Response> updateCommunity(
      {required Map data, required String idToken}) async {
    String body = json.encode(data);
    return await http.put(
      Uri.parse("$communityUrl/${data["id"]}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );
  }
}
