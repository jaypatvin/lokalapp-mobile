import 'dart:convert';

import 'package:http/http.dart' as http;

class SubscriptionService {
  static SubscriptionService? _instance;
  static SubscriptionService? get instance {
    return _instance ??= SubscriptionService();
  }

  String get _url =>
      'https://us-central1-lokal-1baac.cloudfunctions.net/api/v1/productSubscriptionPlans';

  // --POST
  Future<http.Response> createSubscriptionPlan({
    required String? idToken,
    required Map data,
  }) async {
    final body = json.encode(data);
    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken'
      },
      body: body,
    );

    return response;
  }

  Future<http.Response> autoReschedulePlan({
    required String? idToken,
    required String? planId,
  }) async {
    final response = await http.post(
      Uri.parse('$_url/$planId/autoRescheduleConflicts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken'
      },
    );

    return response;
  }

  // --PUT
  Future<http.Response> confirmSubscriptionPlan({
    required String idToken,
    required String planId,
  }) async {
    final response = await http.put(
      Uri.parse('$_url/$planId/confirm'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken'
      },
    );

    return response;
  }

  Future<http.Response> manualReschedulePlan({
    required String? idToken,
    required String? planId,
    required Map data,
  }) async {
    final body = json.encode(data);

    final response = await http.put(
      Uri.parse('$_url/$planId/overrideDates'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken'
      },
      body: body,
    );

    return response;
  }
}
