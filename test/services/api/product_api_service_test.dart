import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:lokalapp/models/failure_exception.dart';
import 'package:lokalapp/models/operating_hours.dart';
import 'package:lokalapp/models/post_requests/product/product_create.request.dart';
import 'package:lokalapp/models/post_requests/product/product_review.request.dart';
import 'package:lokalapp/models/post_requests/product/product_update.request.dart';
import 'package:lokalapp/models/post_requests/shop/operating_hours.request.dart';
import 'package:lokalapp/models/product.dart';
import 'package:lokalapp/models/status.dart';
import 'package:lokalapp/services/api/api.dart';
import 'package:lokalapp/services/api/client/lokal_http_client.dart';
import 'package:lokalapp/services/api/product_api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'product_api_service_test.mocks.dart';
import 'responses/product_api_service.responses.dart' as response;

@GenerateMocks([API, LokalHttpClient])
void main() {
  group('ProductAPIService', () {
    final api = MockAPI();
    final client = MockLokalHttpClient();
    final service = ProductApiService(api, client: client);

    final someUri = Uri.parse('https://success.example.com');
    const headers = <String, String>{'idToken': 'valid'};

    group('create', () {
      const request = ProductCreateRequest(
        name: 'someName',
        description: 'someDescription',
        shopId: 'someShopId',
        basePrice: 20.0,
        quantity: 100,
        productCategory: 'food',
        status: Status.enabled,
        canSubscribe: true,
      );

      when(api.withBodyHeader()).thenReturn(headers);
      when(
        api.endpointUri(Endpoint.product),
      ).thenReturn(someUri);

      test('A [Product] should be returned when successful', () async {
        when(client.post(someUri, headers: headers, body: json.encode(request)))
            .thenAnswer((_) async => http.Response(response.product, 200));

        expect(await service.create(request: request), isA<Product>());
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(client.post(someUri, headers: headers, body: json.encode(request)))
            .thenAnswer((_) async => http.Response(response.error, 400));

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
          client.post(someUri, headers: headers, body: json.encode(request)),
        ).thenAnswer((_) async => http.Response(response.missingKeys, 200));

        expect(
          () async => service.create(request: request),
          throwsA(isA<MissingRequiredKeysException>()),
        );
        reset(client);
      });
    });

    group('review', () {
      const productId = 'productId';
      const request = ProductReviewRequest(orderId: 'orderId', rating: 5);

      when(api.withBodyHeader()).thenReturn(headers);
      when(
        api.endpointUri(Endpoint.product, pathSegments: [productId, 'reviews']),
      ).thenReturn(someUri);

      test('A value of [true] should be returned when successful', () async {
        when(
          client.post(someUri, headers: headers, body: json.encode(request)),
        ).thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.review(productId: productId, request: request),
          isTrue,
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(
          client.post(someUri, headers: headers, body: json.encode(request)),
        ).thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.review(productId: productId, request: request),
          isFalse,
        );
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(
          client.post(someUri, headers: headers, body: json.encode(request)),
        ).thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.review(productId: productId, request: request),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('like', () {
      const productId = 'productId';

      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(Endpoint.product, pathSegments: [productId, 'like']),
      ).thenReturn(someUri);

      test('A value of [true] should be returned when successful', () async {
        when(client.post(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.like(productId: productId),
          isTrue,
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.post(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.like(productId: productId),
          isFalse,
        );
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(client.post(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.like(productId: productId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('addToWishlist', () {
      const productId = 'productId';

      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(
          Endpoint.product,
          pathSegments: [productId, 'wishlist'],
        ),
      ).thenReturn(someUri);

      test('A value of [true] should be returned when successful', () async {
        when(client.post(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.addToWishlist(productId: productId),
          isTrue,
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.post(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.addToWishlist(productId: productId),
          isFalse,
        );
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(client.post(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.addToWishlist(productId: productId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('update', () {
      const productId = 'productId';
      const request = ProductUpdateRequest(name: 'new name');

      when(api.withBodyHeader()).thenReturn(headers);
      when(
        api.endpointUri(
          Endpoint.product,
          pathSegments: [productId],
        ),
      ).thenReturn(someUri);

      test('A value of [true] should be returned when successful', () async {
        when(client.put(someUri, headers: headers, body: json.encode(request)))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.update(productId: productId, request: request),
          isTrue,
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.put(someUri, headers: headers, body: json.encode(request)))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.update(productId: productId, request: request),
          isFalse,
        );
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(client.put(someUri, headers: headers, body: json.encode(request)))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.update(productId: productId, request: request),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('setAvailability', () {
      const productId = 'productId';
      const request = OperatingHoursRequest(
        startDates: ['some-date'],
        unavailableDates: ['some-date'],
        customDates: [
          CustomDates(
            date: 'some-date',
            endTime: 'some-end-time',
            startTime: 'some-start-time',
          )
        ],
      );

      when(api.withBodyHeader()).thenReturn(headers);
      when(
        api.endpointUri(
          Endpoint.product,
          pathSegments: [productId, 'availability'],
        ),
      ).thenReturn(someUri);

      test('A value of [true] should be returned when successful', () async {
        when(client.put(someUri, headers: headers, body: json.encode(request)))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.setAvailability(productId: productId, request: request),
          isTrue,
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.put(someUri, headers: headers, body: json.encode(request)))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.setAvailability(productId: productId, request: request),
          isFalse,
        );
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(client.put(someUri, headers: headers, body: json.encode(request)))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async =>
              service.setAvailability(productId: productId, request: request),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('getCommunityProducts', () {
      const communityId = 'communityId';
      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(
          Endpoint.community,
          pathSegments: [communityId, 'products'],
        ),
      ).thenReturn(someUri);

      test('A [List<Product>] should be returned when successful', () async {
        when(client.get(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.list, 200));
        expect(
          await service.getCommunityProducts(communityId: communityId),
          isA<List<Product>>(),
        );
        reset(client);
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(client.get(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));
        expect(
          () async => service.getCommunityProducts(communityId: communityId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () {
        when(client.get(someUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.missingKeysList, 200),
        );
        expect(
          () async => service.getCommunityProducts(communityId: communityId),
          throwsA(isA<MissingRequiredKeysException>()),
        );
        reset(client);
      });
    });

    group('getAvailableProducts', () {
      when(api.authHeader()).thenReturn(headers);
      when(
        api.baseUri(
          pathSegments: const ['availableProducts'],
        ),
      ).thenReturn(someUri);

      test('A [List<Product>] should be returned when successful', () async {
        when(client.get(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.list, 200));
        expect(
          await service.getAvailableProducts(),
          isA<List<Product>>(),
        );
        reset(client);
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(client.get(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));
        expect(
          () async => service.getAvailableProducts(),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () {
        when(client.get(someUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.missingKeysList, 200),
        );
        expect(
          () async => service.getAvailableProducts(),
          throwsA(isA<MissingRequiredKeysException>()),
        );
        reset(client);
      });
    });

    group('getUserProducts', () {
      const userId = 'userId';
      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(
          Endpoint.user,
          pathSegments: [userId, 'products'],
        ),
      ).thenReturn(someUri);

      test('A [List<Product>] should be returned when successful', () async {
        when(client.get(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.list, 200));
        expect(
          await service.getUserProducts(userId: userId),
          isA<List<Product>>(),
        );
        reset(client);
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(client.get(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));
        expect(
          () async => service.getUserProducts(userId: userId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () {
        when(client.get(someUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.missingKeysList, 200),
        );
        expect(
          () async => service.getUserProducts(userId: userId),
          throwsA(isA<MissingRequiredKeysException>()),
        );
        reset(client);
      });
    });

    group('getRecommendedProducts', () {
      const userId = 'userId';
      const communityId = 'communityId';
      when(api.authHeader()).thenReturn(headers);
      when(
        api.baseUri(
          pathSegments: ['recommendedProducts'],
          queryParameters: {
            'user_id': userId,
            'community_id': communityId,
          },
        ),
      ).thenReturn(someUri);

      test('A [List<Product>] should be returned when successful', () async {
        when(client.get(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.list, 200));
        expect(
          await service.getRecommendedProducts(
            userId: userId,
            communityId: communityId,
          ),
          isA<List<Product>>(),
        );
        reset(client);
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(client.get(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));
        expect(
          () async => service.getRecommendedProducts(
            userId: userId,
            communityId: communityId,
          ),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () {
        when(client.get(someUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.missingKeysList, 200),
        );
        expect(
          () async => service.getRecommendedProducts(
            userId: userId,
            communityId: communityId,
          ),
          throwsA(isA<MissingRequiredKeysException>()),
        );
        reset(client);
      });
    });

    group('getUserWishlist', () {
      const userId = 'userId';
      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(
          Endpoint.user,
          pathSegments: [userId, 'wishlist'],
        ),
      ).thenReturn(someUri);

      test('A [List<Product>] should be returned when successful', () async {
        when(client.get(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.list, 200));
        expect(
          await service.getUserWishlist(userId: userId),
          isA<List<Product>>(),
        );
        reset(client);
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(client.get(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));
        expect(
          () async => service.getUserWishlist(userId: userId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () {
        when(client.get(someUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.missingKeysList, 200),
        );
        expect(
          () async => service.getUserWishlist(userId: userId),
          throwsA(isA<MissingRequiredKeysException>()),
        );
        reset(client);
      });
    });

    group('getById', () {
      const productId = 'productId';
      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(
          Endpoint.product,
          pathSegments: [productId],
        ),
      ).thenReturn(someUri);

      test('A [Product] should be returned when successful', () async {
        when(client.get(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.product, 200));

        expect(await service.getById(productId: productId), isA<Product>());
        reset(client);
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(client.get(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.getById(productId: productId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () {
        when(client.get(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.missingKeys, 200));
        expect(
          () async => service.getById(productId: productId),
          throwsA(isA<MissingRequiredKeysException>()),
        );
        reset(client);
      });
    });

    group('getAvailability', () {
      const productId = 'productId';
      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(
          Endpoint.product,
          pathSegments: [productId, 'availability'],
        ),
      ).thenReturn(someUri);

      test('An [OperatingHours] should be returned when successful', () async {
        when(client.get(someUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.operatingHours, 200),
        );

        expect(
          await service.getAvailability(productId: productId),
          isA<OperatingHours>(),
        );
        reset(client);
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(client.get(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.getAvailability(productId: productId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () {
        when(client.get(someUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.missingKeysOperatingHours, 200),
        );
        expect(
          () async => service.getAvailability(productId: productId),
          throwsA(isA<MissingRequiredKeysException>()),
        );
        reset(client);
      });
    });

    group('deleteProduct', () {
      const productId = 'productId';

      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(Endpoint.product, pathSegments: [productId]),
      ).thenReturn(someUri);

      test('A value of [true] should be returned when successful', () async {
        when(client.delete(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.deleteProduct(productId: productId),
          isTrue,
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.delete(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.deleteProduct(productId: productId),
          isFalse,
        );
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(client.delete(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.deleteProduct(productId: productId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('unlike', () {
      const productId = 'productId';

      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(Endpoint.product, pathSegments: [productId, 'unlike']),
      ).thenReturn(someUri);

      test('A value of [true] should be returned when successful', () async {
        when(client.delete(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.unlike(productId: productId),
          isTrue,
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.delete(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.unlike(productId: productId),
          isFalse,
        );
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(client.delete(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.unlike(productId: productId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('removeFromWishlist', () {
      const productId = 'productId';

      when(api.authHeader()).thenReturn(headers);
      when(
        api.endpointUri(
          Endpoint.product,
          pathSegments: [productId, 'wishlist'],
        ),
      ).thenReturn(someUri);

      test('A value of [true] should be returned when successful', () async {
        when(client.delete(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.removeFromWishlist(productId: productId),
          isTrue,
        );
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(client.delete(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.removeFromWishlist(productId: productId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.delete(someUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.removeFromWishlist(productId: productId),
          isFalse,
        );
        reset(client);
      });
    });
  });
}
