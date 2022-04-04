import 'package:http/http.dart' as http;
import 'package:lokalapp/models/failure_exception.dart';
import 'package:lokalapp/services/api/api.dart';
import 'package:lokalapp/services/api/client/lokal_http_client.dart';
import 'package:lokalapp/services/api/search_api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'responses/search_api_service.responses.dart' as response;
import 'search_api_service_test.mocks.dart';

@GenerateMocks([API, LokalHttpClient])
void main() {
  final api = MockAPI();
  final client = MockLokalHttpClient();
  final service = SearchAPIService(api, client: client);

  final uriWithParameters = Uri.parse('https://success.example.com');
  final uriWithNoParameters = Uri.parse('https://unsuccessful.example.com');
  const headers = <String, String>{'idToken': 'valid'};

  group('SearchAPIService', () {
    group('search', () {
      const query = 'someQuery';
      const communityId = 'someCommunityId';

      when(api.authHeader()).thenReturn(headers);

      test('A [Map<String, dynamic>] should be returned when successful',
          () async {
        const qp = {'q': query, 'community_id': communityId};
        when(api.endpointUri(Endpoint.search, queryParameters: qp))
            .thenReturn(uriWithParameters);
        when(
          client.get(
            uriWithParameters,
            headers: headers,
          ),
        ).thenAnswer((_) async => http.Response(response.success, 200));

        expect(
          await service.search(query: query, communityId: communityId),
          isA<Map<String, dynamic>>(),
        );
      });

      test(
        'A [FailureException] should be thrown when there are no results',
        () {
          const qp = {'q': query, 'community_id': communityId};
          when(api.endpointUri(Endpoint.search, queryParameters: qp))
              .thenReturn(uriWithParameters);
          when(
            client.get(
              uriWithParameters,
              headers: headers,
            ),
          ).thenAnswer((_) async => http.Response(response.emptyResult, 200));

          expect(
            () async => service.search(query: query, communityId: communityId),
            throwsA(isA<FailureException>()),
          );
        },
      );

      test('A [FailureException] should be thrown when unsucessful', () {
        const qp = {'q': query, 'community_id': communityId};
        when(api.endpointUri(Endpoint.search, queryParameters: qp))
            .thenReturn(uriWithParameters);
        when(
          client.get(
            uriWithParameters,
            headers: headers,
          ),
        ).thenAnswer((_) async => http.Response(response.error, 500));

        expect(
          () async => service.search(query: query, communityId: communityId),
          throwsA(isA<FailureException>()),
        );
      });
    });
  });
}
