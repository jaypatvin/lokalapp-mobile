import 'dart:convert';

import 'package:http/http.dart' as http;

import 'lokal_api_constants.dart';

class ShopsService {
  static ShopsService? _instance;
  static ShopsService? get instance {
    if (_instance == null) {
      _instance = ShopsService();
    }
    return _instance;
  }

  // --POST
  Future<http.Response> create(
      {required Map data, required String? idToken}) async {
    var body = json.encode(data);
    var response = await http.post(
      Uri.parse(shopsUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );

    return response;
  }

  // --PUT
  Future<http.Response> update(
      {required Map data, required String? idToken, String? id}) async {
    var body = json.encode(data);
    http.Response response = await http.put(
      Uri.parse("$shopsUrl/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );

    return response;
  }

  Future<http.Response> setOperatingHours({
    required Map data,
    required String? idToken,
    required String? id,
  }) async {
    var body = json.encode(data);
    http.Response response = await http.put(
      Uri.parse("$shopsUrl/$id/operatingHours"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );

    return response;
  }

  // --GET

  Future<http.Response> getById(
      {required String shopId, required String idToken}) async {
    return await http.get(
      Uri.parse("$shopsUrl/$shopId"),
      headers: {"Authorization": "Bearer $idToken"},
    );
  }

  Future<http.Response> getShopsByCommunity(
      {required String? communityId, required String? idToken}) async {
    return await http.get(
      Uri.parse("$communityUrl/$communityId/shops"),
      headers: {"Authorization": "Bearer $idToken"},
    );
  }

  Future<http.Response> getByUserId(
      {required String userId, required String idToken}) async {
    return await http.get(
      Uri.parse("$usersUrl/$userId/shops"),
      headers: {"Authorization": "Bearer $idToken"},
    );
  }

  Future<http.Response> getOperatingHours(
      {required String shopId, required String idToken}) async {
    return await http.get(
      Uri.parse("$shopsUrl/$shopId/operatingHours"),
      headers: {"Authorization": "Bearer $idToken"},
    );
  }
}
