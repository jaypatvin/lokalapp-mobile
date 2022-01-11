import 'dart:convert';

import '../../models/product_subscription_plan.dart';
import 'api.dart';
import 'api_service.dart';

class SubscriptionPlanAPIService extends APIService<ProductSubscriptionPlan> {
  const SubscriptionPlanAPIService(this.api);

  final API api;
  Endpoint get endpoint => Endpoint.subscriptionPlan;

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
    try {
      final response = await poster(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: json.encode(body),
      );

      return handleResponse(
        (map) => ProductSubscriptionPlan.fromMap(map),
        response,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> autoRescheduleConflicts({
    required String planId,
  }) async {
    try {
      final response = await poster(
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
    } catch (e) {
      rethrow;
    }
  }

  // --PUT
  Future<bool> confirmSubscriptionPlan({
    required String planId,
  }) async {
    try {
      final response = await putter(
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
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> manualReschedulePlan({
    required String planId,
    required Map body,
  }) async {
    try {
      final response = await putter(
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
    } catch (e) {
      rethrow;
    }
  }
}
