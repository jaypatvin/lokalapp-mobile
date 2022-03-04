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
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await poster(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(body)),
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
  /// Enables the Subscription Plan. Can only be called by the seller.
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
    required Map<String, dynamic> body,
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
        body: json.encode(trimBodyFields(body)),
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

  /// Cancel the Subscription Plan. Can only be called by the seller.
  Future<bool> cancelSubscriptionPlan({required String planId}) async {
    try {
      final response = await putter(
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
      final response = await putter(
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
