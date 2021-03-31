import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'lokal_api_constants.dart';

class ProductsService {
  static ProductsService _instance;
  static ProductsService get instance {
    if (_instance == null) {
      _instance = ProductsService();
    }
    return _instance;
  }

  // --POST
  Future<http.Response> create(
      {@required Map data, @required String idToken}) async {
    var body = json.encode(data);
    var response = await http.post(
      "$productsUrl",
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
      {@required String productId,
      @required Map data,
      @required String idToken}) async {
    var body = json.encode(data);
    return await http.post(
      "$productsUrl/$productId",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken",
        body: body,
      },
    );
  }

  // --GET
  Future<http.Response> getCommunityProducts(
      {@required String communityId, @required String idToken}) async {
    return await http.get("$communityUrl/$communityId/products",
        headers: {"Authorization": "Bearer $idToken"});
  }

  Future<http.Response> getById(
      {@required String productId, @required String idToken}) async {
    return await (http.get("$productsUrl/$productId",
        headers: {"Authorization": "Bearer $idToken"}));
  }

  Future<http.Response> getUserProducts(
      {@required String userId, @required idToken}) async {
    return await (http.get("$usersUrl/$userId/products",
        headers: {"Authorization": "Bearer $idToken"}));
  }
}
