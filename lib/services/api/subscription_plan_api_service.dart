import 'dart:convert';

import '../../models/failure_exception.dart';
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
    try {
      final queryParameters = <String, dynamic>{};

      if (startDate != null) {
        queryParameters['start_date'] = startDate;
      }
      if (endDate != null) {
        queryParameters['end_date'] = endDate;
      }

      final response = await getter(
        api.endpointUri(
          endpoint,
          pathSegments: [planId],
          queryParameters: queryParameters,
        ),
        headers: api.authHeader(),
      );

      if (response.statusCode == 200) {
        final map = json.decode(response.body);
        final List<String> objects = [];

        for (final String data in map['data']) {
          objects.add(data);
        }
        return objects;
      } else {
        try {
          final map = json.decode(response.body);
          if (map['data'] != null) {
            throw throw FailureException(map['data']);
          }

          if (map['message'] != null) {
            throw FailureException(map['message']);
          }

          throw FailureException(
            response.reasonPhrase ?? 'Error parsing data.',
          );
        } on FormatException {
          throw FailureException('Bad response format');
        }
      }
    } catch (e) {
      rethrow;
    }
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

  Future<bool> disableSubscriptionPlan({required String planId}) async {
    try {
      final response = await putter(
        api.endpointUri(
          endpoint,
          pathSegments: [
            planId,
            'disable',
          ],
        ),
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }
}
