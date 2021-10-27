import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/product_subscription_plan.dart';
import 'api.dart';
import 'api_service.dart';

class SubscriptionPlanAPIService extends APIService<ProductSubscriptionPlan> {
  const SubscriptionPlanAPIService(this.api);

  final API api;
  final Endpoint endpoint = Endpoint.subscription_plan;

  // -- GET
  Future<List<String>> getAvailableDates({
    required String planId,
    String? startDate,
    String? endDate,
  }) async {
    // TODO: Implement function
    throw UnimplementedError();
  }

  // -- POST

  Future<ProductSubscriptionPlan> createSubscriptionPlan({
    required Map<String, dynamic> body,
  }) async {
    final response = await http.post(
      api.endpointUri(endpoint),
      headers: api.withBodyHeader(),
      body: json.encode(body),
    );

    return handleResponse(
      (map) => ProductSubscriptionPlan.fromMap(map),
      response,
    );
  }

  Future<bool> autoRescheduleConflicts({
    required String planId,
  }) async {
    final response = await http.post(
      api.endpointUri(
        endpoint,
        pathSegments: [
          planId,
          'autoRescheduleConflicts',
        ],
      ),
      headers: api.authHeader(),
    );

    return handleGenericResponse(response);
  }

  // --PUT
  Future<bool> confirmSubscriptionPlan({
    required String planId,
  }) async {
    final response = await http.put(
      api.endpointUri(
        endpoint,
        pathSegments: [
          planId,
          'confirm',
        ],
      ),
      headers: api.authHeader(),
    );

    return handleGenericResponse(response);
  }

  Future<bool> manualReschedulePlan({
    required String planId,
    required Map body,
  }) async {
    final response = await http.put(
      api.endpointUri(
        endpoint,
        pathSegments: [
          planId,
          'overrideDates',
        ],
      ),
      headers: api.withBodyHeader(),
      body: json.encode(body),
    );

    return handleGenericResponse(response);
  }
}
