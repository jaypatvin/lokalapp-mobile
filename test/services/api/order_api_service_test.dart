import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:lokalapp/models/failure_exception.dart';
import 'package:lokalapp/models/order.dart' as order;
import 'package:lokalapp/models/post_requests/orders/order_create.request.dart';
import 'package:lokalapp/models/post_requests/orders/order_pay.request.dart';
import 'package:lokalapp/services/api/api.dart';
import 'package:lokalapp/services/api/client/lokal_http_client.dart';
import 'package:lokalapp/services/api/order_api.dart';
import 'package:lokalapp/services/api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'order_api_service_test.mocks.dart';
import 'responses/order_api_service.responses.dart' as response;

@GenerateMocks([APIService, LokalHttpClient])
void main() {
  group('OrderAPIService', () {
    final api = MockAPIService();
    final client = MockLokalHttpClient();
    final service = OrderAPI();

    final someUri = Uri.parse('https://success.example.com');
    const headers = <String, String>{'idToken': 'valid'};

    group('create', () {
      final request = OrderCreateRequest(
        products: [const OrderCreateProduct(id: 'id', quantity: 1)],
        shopId: 'shopId',
        deliveryOption: order.DeliveryOption.pickup,
        deliveryDate: DateTime.now(),
      );
      when(api.withBodyHeader()).thenReturn(headers);
      when(
        api.endpointUri(Endpoint.order),
      ).thenReturn(someUri);
      test('An [Order] should be returned when successful', () async {
        when(
          client.post(
            someUri,
            headers: headers,
            body: json.encode(request),
          ),
        ).thenAnswer((_) async => http.Response(response.success, 200));

        expect(await service.create(request: request), isA<order.Order>());
        reset(client);
      });

      test('A [FailureException] should be thrown when unsuccessful', () async {
        when(
          client.post(
            someUri,
            headers: headers,
            body: json.encode(request),
          ),
        ).thenAnswer((_) async => http.Response(response.failure, 400));

        expect(
          () async => service.create(request: request),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () {
        when(
          client.post(
            someUri,
            headers: headers,
            body: json.encode(request),
          ),
        ).thenAnswer((_) async => http.Response(response.missingKey, 200));

        expect(
          () async => service.create(request: request),
          throwsA(isA<MissingRequiredKeysException>()),
        );
        reset(client);
      });
    });

    group('confirm', () {
      const orderId = 'someOrderId';

      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(Endpoint.order, pathSegments: [orderId, 'confirm']),
      ).thenReturn(someUri);
      test('A value of [true] should be returned when successful', () async {
        when(
          client.put(someUri, headers: headers),
        ).thenAnswer((_) async => http.Response(response.ok, 200));

        expect(await service.confirm(orderId: orderId), isTrue);
        reset(client);
      });
      test('A value of [false] should be returned when unsuccessful', () async {
        when(
          client.put(someUri, headers: headers),
        ).thenAnswer((_) async => http.Response(response.error, 200));

        expect(await service.confirm(orderId: orderId), isFalse);
        reset(client);
      });
      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(
          client.put(someUri, headers: headers),
        ).thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.confirm(orderId: orderId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('confirmPayment', () {
      const orderId = 'someOrderId';

      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(
          Endpoint.order,
          pathSegments: [orderId, 'confirmPayment'],
        ),
      ).thenReturn(someUri);
      test('A value of [true] should be returned when successful', () async {
        when(
          client.put(someUri, headers: headers),
        ).thenAnswer((_) async => http.Response(response.ok, 200));

        expect(await service.confirmPayment(orderId: orderId), isTrue);
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(
          client.put(someUri, headers: headers),
        ).thenAnswer((_) async => http.Response(response.error, 200));

        expect(await service.confirmPayment(orderId: orderId), isFalse);
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(
          client.put(someUri, headers: headers),
        ).thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.confirmPayment(orderId: orderId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('decline', () {
      const orderId = 'someOrderId';
      final body = json.encode({'reason': ''});
      when(api.withBodyHeader()).thenReturn(headers);
      when(
        api.endpointUri(Endpoint.order, pathSegments: [orderId, 'decline']),
      ).thenReturn(someUri);
      test('A value of [true] should be returned when successful', () async {
        when(
          client.put(someUri, headers: headers, body: body),
        ).thenAnswer((_) async => http.Response(response.ok, 200));

        expect(await service.decline(orderId: orderId), isTrue);
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(
          client.put(someUri, headers: headers, body: body),
        ).thenAnswer((_) async => http.Response(response.error, 200));

        expect(await service.decline(orderId: orderId), isFalse);
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(
          client.put(someUri, headers: headers, body: body),
        ).thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.decline(orderId: orderId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('pay', () {
      const orderId = 'someOrderId';
      final request = OrderPayRequest(paymentMethod: order.PaymentMethod.cod);
      final body = json.encode(request);
      when(api.withBodyHeader()).thenReturn(headers);
      when(
        api.endpointUri(Endpoint.order, pathSegments: [orderId, 'pay']),
      ).thenReturn(someUri);
      test('A value of [true] should be returned when successful', () async {
        when(
          client.put(someUri, headers: headers, body: body),
        ).thenAnswer((_) async => http.Response(response.ok, 200));

        expect(await service.pay(orderId: orderId, request: request), isTrue);
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(
          client.put(someUri, headers: headers, body: body),
        ).thenAnswer((_) async => http.Response(response.error, 200));

        expect(await service.pay(orderId: orderId, request: request), isFalse);
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(
          client.put(someUri, headers: headers, body: body),
        ).thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.pay(orderId: orderId, request: request),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('receive', () {
      const orderId = 'someOrderId';

      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(
          Endpoint.order,
          pathSegments: [orderId, 'receive'],
        ),
      ).thenReturn(someUri);
      test('A value of [true] should be returned when successful', () async {
        when(
          client.put(someUri, headers: headers),
        ).thenAnswer((_) async => http.Response(response.ok, 200));

        expect(await service.receive(orderId: orderId), isTrue);
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(
          client.put(someUri, headers: headers),
        ).thenAnswer((_) async => http.Response(response.error, 200));

        expect(await service.receive(orderId: orderId), isFalse);
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(
          client.put(someUri, headers: headers),
        ).thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.receive(orderId: orderId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('shipOut', () {
      const orderId = 'someOrderId';

      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(
          Endpoint.order,
          pathSegments: [orderId, 'shipOut'],
        ),
      ).thenReturn(someUri);
      test('A value of [true] should be returned when successful', () async {
        when(
          client.put(someUri, headers: headers),
        ).thenAnswer((_) async => http.Response(response.ok, 200));

        expect(await service.shipOut(orderId: orderId), isTrue);
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(
          client.put(someUri, headers: headers),
        ).thenAnswer((_) async => http.Response(response.error, 200));

        expect(await service.shipOut(orderId: orderId), isFalse);
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(
          client.put(someUri, headers: headers),
        ).thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.shipOut(orderId: orderId),
          throwsA(isA<FailureException>()),
        );
      });
    });
  });
}
