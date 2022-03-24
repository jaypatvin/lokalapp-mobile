import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:lokalapp/models/community.dart';
import 'package:lokalapp/models/failure_exception.dart';
import 'package:lokalapp/services/api/api.dart';
import 'package:lokalapp/services/api/client/lokal_http_client.dart';
import 'package:lokalapp/services/api/community_api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'community_api_service_test.mocks.dart';
import 'responses/community_api_service.responses.dart' as response;

@GenerateMocks([API, LokalHttpClient])
void main() {
  group('CommunityAPIService', () {
    final api = MockAPI();
    final client = MockLokalHttpClient();
    final service = CommunityAPIService(api, client: client);

    final successUri = Uri.parse('https://success.example.com');
    final unsucessfulUri = Uri.parse('https://unsuccessful.example.com');
    const headers = <String, String>{'idToken': 'valid'};
    const communityId = 'community_id';

    group('getById', () {
      test('A [Community] should be returned when successful', () async {
        when(api.authHeader()).thenReturn(headers);
        when(api.endpointUri(Endpoint.community, pathSegments: [communityId]))
            .thenReturn(successUri);

        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.successResponse, 200),
        );

        expect(await service.getById(communityId), isA<Community>());
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(api.authHeader()).thenReturn(headers);
        when(api.endpointUri(Endpoint.community, pathSegments: [communityId]))
            .thenReturn(unsucessfulUri);

        when(client.get(unsucessfulUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.error404, 404),
        );

        expect(
          () async => service.getById(communityId),
          throwsA(isA<FailureException>()),
        );
      });

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () {
        when(api.authHeader()).thenReturn(headers);
        when(api.endpointUri(Endpoint.community, pathSegments: [communityId]))
            .thenReturn(successUri);

        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.missingKeyResponse, 200),
        );

        expect(
          () async => service.getById(communityId),
          throwsA(isA<MissingRequiredKeysException>()),
        );
      });
    });
  });
}
