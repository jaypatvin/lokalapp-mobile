import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:lokalapp/models/bank_code.dart';
import 'package:lokalapp/models/failure_exception.dart';
import 'package:lokalapp/models/operating_hours.dart';
import 'package:lokalapp/models/payment_option.dart';
import 'package:lokalapp/models/post_requests/shop/operating_hours.request.dart';
import 'package:lokalapp/models/post_requests/shop/shop_create.request.dart';
import 'package:lokalapp/models/post_requests/shop/shop_update.request.dart';
import 'package:lokalapp/models/shop.dart';
import 'package:lokalapp/services/api/api.dart';
import 'package:lokalapp/services/api/client/lokal_http_client.dart';
import 'package:lokalapp/services/api/shop_api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'responses/shop_api_service.responses.dart' as response;
import 'shop_api_service_test.mocks.dart';

@GenerateMocks([API, LokalHttpClient])
void main() {
  final api = MockAPI();
  final client = MockLokalHttpClient();
  final service = ShopAPIService(api, client: client);

  final uri = Uri.parse('https://success.example.com');
  const headers = <String, String>{'idToken': 'valid'};

  group('ShopAPIService', () {
    group('create', () {
      const request = ShopCreateRequest(
        name: 'name',
        description: 'description',
        userId: 'userId',
        paymentOptions: [
          PaymentOption(
            bankCode: 'bankCode',
            accountName: 'accountName',
            accountNumber: 'accountNumber',
            type: BankType.bank,
          ),
        ],
        operatingHours: OperatingHoursRequest(
          startDates: ['startDate'],
          unavailableDates: ['unavailableDate'],
          customDates: [
            CustomDates(
              date: 'today',
              endTime: '5:00 PM',
              startTime: '8:00 AM',
            )
          ],
        ),
      );

      when(api.endpointUri(Endpoint.shop)).thenReturn(uri);
      when(api.withBodyHeader()).thenReturn(headers);

      test('A [Shop] should be returned when successful', () async {
        when(
          client.post(
            uri,
            headers: headers,
            body: json.encode(request.toJson()),
          ),
        ).thenAnswer((_) async => http.Response(response.success, 200));

        expect(await service.create(request: request), isA<Shop>());
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
            () async => service.create(request: request),
            throwsA(isA<FailureException>()),
          );
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
          () async => service.create(request: request),
          throwsA(isA<MissingRequiredKeysException>()),
        );
      });
    });

    group('update', () {
      const request = ShopUpdateRequest(
        name: 'someName',
        description: 'someDescription',
      );
      const id = 'shopId';

      when(api.endpointUri(Endpoint.shop, pathSegments: [id])).thenReturn(uri);
      when(api.withBodyHeader()).thenReturn(headers);

      test('A value of [true] should be returned when successful', () async {
        when(client.put(uri, headers: headers, body: json.encode(request)))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.update(id: id, request: request),
          isTrue,
        );
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.put(uri, headers: headers, body: json.encode(request)))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.update(id: id, request: request),
          isFalse,
        );
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(client.put(uri, headers: headers, body: json.encode(request)))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.update(id: id, request: request),
          throwsA(isA<FailureException>()),
        );
      });
    });

    group('setOperatingHours', () {
      const request = OperatingHoursRequest(
        startDates: ['startDate'],
        unavailableDates: ['unavailableDate'],
        customDates: [
          CustomDates(
            date: 'today',
            endTime: '5:00 PM',
            startTime: '8:00 AM',
          )
        ],
      );
      const id = 'shopId';

      when(api.endpointUri(Endpoint.shop, pathSegments: [id, 'operatingHours']))
          .thenReturn(uri);
      when(api.withBodyHeader()).thenReturn(headers);

      test('A value of [true] should be returned when successful', () async {
        when(client.put(uri, headers: headers, body: json.encode(request)))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.setOperatingHours(id: id, request: request),
          isTrue,
        );
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.put(uri, headers: headers, body: json.encode(request)))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.setOperatingHours(id: id, request: request),
          isFalse,
        );
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(client.put(uri, headers: headers, body: json.encode(request)))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.setOperatingHours(id: id, request: request),
          throwsA(isA<FailureException>()),
        );
      });
    });

    group('getById', () {
      const id = 'shopId';
      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(
          Endpoint.product,
          pathSegments: [id],
        ),
      ).thenReturn(uri);

      test('A [Shop] should be returned when successful', () async {
        when(client.get(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.success, 200));

        expect(await service.getById(id: id), isA<Shop>());
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(client.get(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.getById(id: id),
          throwsA(isA<FailureException>()),
        );
      });

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () {
        when(client.get(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.missingKeys, 200));
        expect(
          () async => service.getById(id: id),
          throwsA(isA<MissingRequiredKeysException>()),
        );
      });
    });

    group('getCommunityShops', () {
      const communityId = 'communityId';

      when(
        api.endpointUri(
          Endpoint.community,
          pathSegments: [communityId, 'shops'],
        ),
      ).thenReturn(uri);
      when(api.authHeader()).thenReturn(headers);

      test('A [List<Shop>] should be returned when successful', () async {
        when(client.get(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.list, 200));
        expect(
          await service.getCommunityShops(communityId: communityId),
          isA<List<Shop>>(),
        );
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(client.get(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));
        expect(
          () async => service.getCommunityShops(communityId: communityId),
          throwsA(isA<FailureException>()),
        );
      });

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () {
        when(client.get(uri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.missingKeysList, 200),
        );
        expect(
          () async => service.getCommunityShops(communityId: communityId),
          throwsA(isA<MissingRequiredKeysException>()),
        );
      });
    });

    group('getByUserId', () {
      const userId = 'userId';

      when(
        api.endpointUri(
          Endpoint.user,
          pathSegments: [userId, 'shops'],
        ),
      ).thenReturn(uri);
      when(api.authHeader()).thenReturn(headers);

      test('A [List<Shop>] should be returned when successful', () async {
        when(client.get(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.list, 200));
        expect(
          await service.getByUserId(userId: userId),
          isA<List<Shop>>(),
        );
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(client.get(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));
        expect(
          () async => service.getByUserId(userId: userId),
          throwsA(isA<FailureException>()),
        );
      });

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () {
        when(client.get(uri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.missingKeysList, 200),
        );
        expect(
          () async => service.getByUserId(userId: userId),
          throwsA(isA<MissingRequiredKeysException>()),
        );
      });
    });

    group('getOperatingHours', () {
      const shopId = 'shopId';

      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(
          Endpoint.shop,
          pathSegments: [shopId, 'operatingHours'],
        ),
      ).thenReturn(uri);

      test('An [OperatingHours] should be returned when successful', () async {
        when(client.get(uri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.operatingHours, 200),
        );

        expect(
          await service.getOperatingHours(shopId: shopId),
          isA<OperatingHours>(),
        );
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(client.get(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.getOperatingHours(shopId: shopId),
          throwsA(isA<FailureException>()),
        );
      });

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () {
        when(client.get(uri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.missingKeysOperatingHours, 200),
        );
        expect(
          () async => service.getOperatingHours(shopId: shopId),
          throwsA(isA<MissingRequiredKeysException>()),
        );
      });
    });

    group('getAvailableShops', () {
      const communityId = 'communityId';

      when(
        api.baseUri(
          pathSegments: ['availableShops'],
          queryParameters: <String, String>{'community_id': communityId},
        ),
      ).thenReturn(uri);
      when(api.authHeader()).thenReturn(headers);

      test('A [List<Shop>] should be returned when successful', () async {
        when(client.get(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.list, 200));
        expect(
          await service.getAvailableShops(communityId: communityId),
          isA<List<Shop>>(),
        );
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(client.get(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));
        expect(
          () async => service.getAvailableShops(communityId: communityId),
          throwsA(isA<FailureException>()),
        );
      });

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () {
        when(client.get(uri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.missingKeysList, 200),
        );
        expect(
          () async => service.getAvailableShops(communityId: communityId),
          throwsA(isA<MissingRequiredKeysException>()),
        );
      });
    });
  });
}
