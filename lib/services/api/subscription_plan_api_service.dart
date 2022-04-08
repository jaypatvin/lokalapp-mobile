import 'dart:convert';

import '../../models/failure_exception.dart';
import '../../models/post_requests/product_subscription_plan/override_dates.request.dart';
import '../../models/post_requests/product_subscription_plan/product_subscription_plan.request.dart';
import '../../models/product_subscription_plan.dart';
import 'api.dart';
import 'api_service.dart';
import 'client/lokal_http_client.dart';

class SubscriptionPlanAPIService extends APIService<ProductSubscriptionPlan> {
  SubscriptionPlanAPIService(this.api, {LokalHttpClient? client})
      : super(client: client ?? LokalHttpClient());

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

      final response = await client.get(
        api.endpointUri(
          endpoint,
          pathSegments: [planId, 'getDates'],
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
            response.body,
          );
        } on FormatException {
          throw FailureException('Bad response format', response.body);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  // -- POST

  Future<ProductSubscriptionPlan> createSubscriptionPlan({
    required ProductSubscriptionPlanRequest request,
  }) async {
    try {
      final response = await client.post(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(request.toJson())),
      );

      return handleResponse(
        (map) => ProductSubscriptionPlan.fromJson(map),
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
      final response = await client.post(
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
  /// Enables the Subscription Plan. Can only be called by the seller.
  Future<bool> confirmSubscriptionPlan({
    required String planId,
  }) async {
    try {
      final response = await client.put(
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
    required OverrideDatesRequest request,
  }) async {
    try {
      final response = await client.put(
        api.endpointUri(
          endpoint,
          pathSegments: [
            planId,
            'overrideDates',
          ],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(request.toJson()),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Disables the Subscription Plan. Can be called by either the buyer or the
  /// seller.
  ///
  /// This shouldn't be used to cancel or unsubsribe from the subscription.
  /// Use the methods `[cancelSubscriptionPlan]` or
  /// `[unsubscribeFromSubscriptionPlan]` instead.
  Future<bool> disableSubscriptionPlan({required String planId}) async {
    try {
      final response = await client.put(
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

  /// Cancel the Subscription Plan. Can only be called by the seller.
  Future<bool> cancelSubscriptionPlan({required String planId}) async {
    try {
      final response = await client.put(
        api.endpointUri(
          endpoint,
          pathSegments: [planId, 'cancel'],
        ),
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Unsubscribe from the Subscription Plan. Can only be called by the
  /// buyer.
  Future<bool> unsubscribeFromSubscriptionPlan({required String planId}) async {
    try {
      final response = await client.put(
        api.endpointUri(
          endpoint,
          pathSegments: [planId, 'unsubscribe'],
        ),
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }
}
