import 'dart:convert';

import 'package:http/http.dart' as http;

import 'lokal_api_constants.dart';

class OrdersService {
  static OrdersService? _instance;

  static OrdersService? get instance {
    if (_instance == null) {
      _instance = OrdersService();
    }
    return _instance;
  }

  // --GET

  // --POST
  Future<http.Response> create({
    required String? idToken,
    required Map data,
  }) async {
    final body = json.encode(data);
    return await http.post(
      Uri.parse(ordersUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );
  }

  // --DELETE

  // --PUT

  Future<http.Response> cancel({
    required String? idToken,
    required String? orderId,
  }) async {
    return await http.put(
      Uri.parse("$ordersUrl/$orderId/cancel"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
    );
  }

  Future<http.Response> confirm({
    required String? idToken,
    required String? orderId,
  }) async {
    return await http.put(
      Uri.parse("$ordersUrl/$orderId/confirm"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
    );
  }

  Future<http.Response> confirmPayment({
    required String? idToken,
    required String? orderId,
  }) async {
    return await http.put(
      Uri.parse("$ordersUrl/$orderId/confirmPayment"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
    );
  }

  Future<http.Response> decline({
    required String? idToken,
    required String? orderId,
  }) async {
    return await http.put(
      Uri.parse("$ordersUrl/$orderId/decline"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
    );
  }

  Future<http.Response> pay({
    required String? idToken,
    required String? orderId,
    required Map data,
  }) async {
    final body = json.encode(data);
    return await http.put(
      Uri.parse("$ordersUrl/$orderId/pay"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );
  }

  Future<http.Response> receive({
    required String? idToken,
    required String? orderId,
  }) async {
    return await http.put(
      Uri.parse("$ordersUrl/$orderId/receive"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
    );
  }

  Future<http.Response> shipOut({
    required String? idToken,
    required String? orderId,
  }) async {
    return await http.put(
      Uri.parse("$ordersUrl/$orderId/shipOut"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
    );
  }
}
