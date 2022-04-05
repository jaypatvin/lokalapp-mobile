import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:lokalapp/models/failure_exception.dart';
import 'package:lokalapp/models/lokal_category.dart';
import 'package:lokalapp/services/api/api.dart';
import 'package:lokalapp/services/api/category_api_service.dart';
import 'package:lokalapp/services/api/client/lokal_http_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'category_api_service_test.mocks.dart';
import 'responses/category_api_service.responses.dart' as response;

@GenerateMocks([API, LokalHttpClient])
void main() {
  group('CategoryAPIService', () {
    final api = MockAPI();
    final client = MockLokalHttpClient();
    final service = CategoryAPIService(api, client: client);

    final successUri = Uri.parse('https://success.example.com');
    final unsucessfulUri = Uri.parse('https://unsuccessful.example.com');
    const headers = <String, String>{'idToken': 'valid'};

    group('getAll', () {
      when(api.authHeader()).thenReturn(headers);
      when(api.withBodyHeader()).thenReturn(headers);
      when(api.endpointUri(Endpoint.category)).thenReturn(successUri);

      test('A List of [LokalCategory] should be return when successful',
          () async {
        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.successListResponse, 200),
        );

        expect(await service.getAll(), isA<List<LokalCategory>>());
        reset(client);
      });

      test('A [FailureException] should be thrown when unsucessful', () {
        when(api.endpointUri(Endpoint.category)).thenReturn(unsucessfulUri);
        when(client.get(unsucessfulUri, headers: headers)).thenAnswer(
          (_) async => http.Response('', 400),
        );

        expect(() async => service.getAll(), throwsA(isA<FailureException>()));
        reset(client);
      });

      test(
          'A MissingRequiredKeysException should be thrown when the returned '
          'json data is incomplete', () async {
        when(api.endpointUri(Endpoint.category)).thenReturn(successUri);
        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.successMissingListResponse, 200),
        );

        expect(
          () async => service.getAll(),
          throwsA(isA<MissingRequiredKeysException>()),
        );
        reset(client);
      });
    });

    group('getById', () {
      test('An instance of [LokalCategory] should be returned when successful',
          () async {
        when(api.endpointUri(Endpoint.category, pathSegments: ['id']))
            .thenReturn(successUri);
        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.successResponse, 200),
        );

        expect(await service.getById(id: 'id'), isA<LokalCategory>());
        reset(client);
      });

      test('A [FailureException] should be thrown when unsuccessful', () async {
        when(api.endpointUri(Endpoint.category, pathSegments: ['id']))
            .thenReturn(unsucessfulUri);
        when(client.get(unsucessfulUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.errorResponse, 400),
        );

        expect(
          () async => service.getById(id: 'id'),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });

      test(
          'A MissingRequiredKeysException should be thrown when the returned '
          'json data is incomplete', () async {
        when(api.endpointUri(Endpoint.category, pathSegments: ['id']))
            .thenReturn(successUri);
        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.successMissingResponse, 200),
        );

        expect(
          () async => service.getById(id: 'id'),
          throwsA(isA<MissingRequiredKeysException>()),
        );
        reset(client);
      });
    });
  });
}
