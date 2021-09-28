import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'lokal_api_constants.dart';

class SubscriptionService {
  static SubscriptionService _instance;
  static SubscriptionService get instance {
    if (_instance == null) {
      _instance = SubscriptionService();
    }
    return _instance;
  }

  // --POST
  Future<http.Response> createSubscriptionPlan({
    @required String idToken,
    @required Map data,
  }) async {
    final body = json.encode(data);
    final response = await http.post(
      "$subscriptionPlansUrl",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );

    return response;
  }

  Future<http.Response> autoReschedulePlan({
    @required String idToken,
    @required String planId,
  }) async {
    final response = await http.post(
      "$subscriptionPlansUrl/$planId/autoRescheduleConflicts",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
    );

    return response;
  }

  // --PUT
  Future<http.Response> confirmSubscriptionPlan({
    @required String idToken,
    @required String planId,
  }) async {
    final response = await http.put(
      "$subscriptionPlansUrl/$planId/confirm",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
    );

    return response;
  }

  Future<http.Response> manualReschedulePlan({
    @required String idToken,
    @required String planId,
    @required Map data,
  }) async {
    final body = json.encode(data);

    final response = await http.put(
      "$subscriptionPlansUrl/$planId/overrideDate",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );

    return response;
  }
}
