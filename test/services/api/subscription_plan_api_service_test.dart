import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:lokalapp/models/failure_exception.dart';
import 'package:lokalapp/models/order.dart';
import 'package:lokalapp/models/post_requests/product_subscription_plan/override_dates.request.dart';
import 'package:lokalapp/models/post_requests/product_subscription_plan/product_subscription_plan.request.dart';
import 'package:lokalapp/models/post_requests/product_subscription_plan/product_subscription_schedule.request.dart';
import 'package:lokalapp/models/product_subscription_plan.dart';
import 'package:lokalapp/services/api/api.dart';
import 'package:lokalapp/services/api/client/lokal_http_client.dart';
import 'package:lokalapp/services/api/subscription_plan_api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'responses/subscription_plan_api_service.responses.dart' as response;
import 'subscription_plan_api_service_test.mocks.dart';

@GenerateMocks([API, LokalHttpClient])
void main() {
  group('SubscriptionPlanAPIService', () {
    final api = MockAPI();
    final client = MockLokalHttpClient();
    final service = SubscriptionPlanAPIService(api, client: client);

    final uri = Uri.parse('https://success.example.com');
    const headers = <String, String>{'idToken': 'valid'};

    group('getAvailableDates', () {
      const planId = 'planId';

      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(
          Endpoint.subscriptionPlan,
          pathSegments: [planId, 'getDates'],
        ),
      ).thenReturn(uri);

      test('A [List<String>] should be returned when successful', () async {
        when(client.get(uri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.dates, 200),
        );

        expect(
          await service.getAvailableDates(planId: planId),
          isA<List<String>>(),
        );
        reset(client);
      });

      test('A [List<String>] should be returned when empty dates are returned',
          () async {
        when(client.get(uri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.emptyDate, 200),
        );

        expect(
          await service.getAvailableDates(planId: planId),
          isA<List<String>>(),
        );
        reset(client);
      });

      test(
        'A [FailureException] should be thrown when unsuccessful',
        () {
          when(client.get(uri, headers: headers)).thenAnswer(
            (_) async => http.Response(response.error, 400),
          );
          expect(
            () async => service.getAvailableDates(planId: planId),
            throwsA(isA<FailureException>()),
          );
          reset(client);
        },
      );
    });

    group('createSubscriptionPlan', () {
      final request = ProductSubscriptionPlanRequest(
        productId: 'productId',
        shopId: 'shopId',
        quantity: 1,
        paymentMethod: PaymentMethod.cod,
        plan: ProductSubscriptionScheduleRequest(
          startDates: [DateTime(2022, 4, 11)],
          repeatUnit: 1,
          repeatType: 'week',
        ),
      );

      when(api.withBodyHeader()).thenReturn(headers);
      when(api.endpointUri(Endpoint.subscriptionPlan)).thenReturn(uri);

      test('A [ProductSubscriptionPlan] should be returned when successful',
          () async {
        when(client.post(uri, headers: headers, body: json.encode(request)))
            .thenAnswer((_) async => http.Response(response.plan, 200));

        expect(
          await service.createSubscriptionPlan(request: request),
          isA<ProductSubscriptionPlan>(),
        );
        reset(client);
      });

      test(
        'A [FailureException] should be thrown when unsuccessful',
        () {
          when(
            client.post(
              uri,
              headers: headers,
              body: json.encode(request.toJson()),
            ),
          ).thenAnswer((_) async => http.Response(response.error, 400));

          expect(
            () async => service.createSubscriptionPlan(request: request),
            throwsA(isA<FailureException>()),
          );
          reset(client);
        },
      );

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () {
        when(
          client.post(
            uri,
            headers: headers,
            body: json.encode(request.toJson()),
          ),
        ).thenAnswer((_) async => http.Response(response.missingKeys, 200));

        expect(
          () async => service.createSubscriptionPlan(request: request),
          throwsA(isA<MissingRequiredKeysException>()),
        );
        reset(client);
      });
    });

    group('autoRescheduleConflicts', () {
      const planId = 'planId';

      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(
          Endpoint.subscriptionPlan,
          pathSegments: [
            planId,
            'autoRescheduleConflicts',
          ],
        ),
      ).thenReturn(uri);

      test('A value of [true] should be returned when successful', () async {
        when(client.post(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.autoRescheduleConflicts(planId: planId),
          isTrue,
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.post(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.autoRescheduleConflicts(planId: planId),
          isFalse,
        );
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(client.post(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.autoRescheduleConflicts(planId: planId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('confirmSubscriptionPlan', () {
      const planId = 'planId';

      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(
          Endpoint.subscriptionPlan,
          pathSegments: [
            planId,
            'confirm',
          ],
        ),
      ).thenReturn(uri);

      test('A value of [true] should be returned when successful', () async {
        when(client.put(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.confirmSubscriptionPlan(planId: planId),
          isTrue,
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.put(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.confirmSubscriptionPlan(planId: planId),
          isFalse,
        );
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(client.put(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.confirmSubscriptionPlan(planId: planId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('manualReschedulePlan', () {
      const planId = 'planId';
      final request = OverrideDatesRequest(
        [
          OverrideDate(
            originalDate: DateTime.now(),
            newDate: DateTime.now().add(const Duration(days: 1)),
          )
        ],
      );

      when(api.withBodyHeader()).thenReturn(headers);
      when(
        api.endpointUri(
          Endpoint.subscriptionPlan,
          pathSegments: [
            planId,
            'overrideDates',
          ],
        ),
      ).thenReturn(uri);

      test('A value of [true] should be returned when successful', () async {
        when(client.put(uri, headers: headers, body: json.encode(request)))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.manualReschedulePlan(planId: planId, request: request),
          isTrue,
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.put(uri, headers: headers, body: json.encode(request)))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.manualReschedulePlan(planId: planId, request: request),
          isFalse,
        );
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(client.put(uri, headers: headers, body: json.encode(request)))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async =>
              service.manualReschedulePlan(planId: planId, request: request),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('disableSubscriptionPlan', () {
      const planId = 'planId';

      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(
          Endpoint.subscriptionPlan,
          pathSegments: [
            planId,
            'disable',
          ],
        ),
      ).thenReturn(uri);

      test('A value of [true] should be returned when successful', () async {
        when(client.put(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.disableSubscriptionPlan(planId: planId),
          isTrue,
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.put(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.disableSubscriptionPlan(planId: planId),
          isFalse,
        );
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(client.put(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.disableSubscriptionPlan(planId: planId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('cancelSubscriptionPlan', () {
      const planId = 'planId';

      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(
          Endpoint.subscriptionPlan,
          pathSegments: [
            planId,
            'cancel',
          ],
        ),
      ).thenReturn(uri);

      test('A value of [true] should be returned when successful', () async {
        when(client.put(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.cancelSubscriptionPlan(planId: planId),
          isTrue,
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.put(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.cancelSubscriptionPlan(planId: planId),
          isFalse,
        );
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(client.put(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.cancelSubscriptionPlan(planId: planId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('unsubscribeFromSubscriptionPlan', () {
      const planId = 'planId';

      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(
          Endpoint.subscriptionPlan,
          pathSegments: [
            planId,
            'unsubscribe',
          ],
        ),
      ).thenReturn(uri);

      test('A value of [true] should be returned when successful', () async {
        when(client.put(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.unsubscribeFromSubscriptionPlan(planId: planId),
          isTrue,
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.put(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.unsubscribeFromSubscriptionPlan(planId: planId),
          isFalse,
        );
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(client.put(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.unsubscribeFromSubscriptionPlan(planId: planId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });
  });
}
