import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:lokalapp/models/failure_exception.dart';
import 'package:lokalapp/models/lokal_invite.dart';
import 'package:lokalapp/models/post_requests/invite.request.dart';
import 'package:lokalapp/services/api/api.dart';
import 'package:lokalapp/services/api/client/lokal_http_client.dart';
import 'package:lokalapp/services/api/invite_api.dart';
import 'package:lokalapp/services/api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'invite_api_service_test.mocks.dart';
import 'responses/invite_api_service.responses.dart' as response;

@GenerateMocks([APIService, LokalHttpClient])
void main() {
  group('InviteAPIService', () {
    final api = MockAPIService();
    final client = MockLokalHttpClient();
    final service = InviteAPI();

    final successUri = Uri.parse('https://success.example.com');
    final unsucessfulUri = Uri.parse('https://unsuccessful.example.com');
    const headers = <String, String>{'idToken': 'valid'};

    group('inviteAFriend', () {
      const email = 'email@example.com';
      const body = {'email': email};

      test('A [LokalInvite] should be returned when successful', () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(Endpoint.invite),
        ).thenReturn(successUri);
        when(
          client.post(successUri, headers: headers, body: json.encode(body)),
        ).thenAnswer((_) async => http.Response(response.success, 200));

        expect(await service.inviteAFriend(email), isA<LokalInvite>());
        reset(client);
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(Endpoint.invite),
        ).thenReturn(unsucessfulUri);
        when(
          client.post(
            unsucessfulUri,
            headers: headers,
            body: json.encode(body),
          ),
        ).thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.inviteAFriend(email),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(Endpoint.invite),
        ).thenReturn(successUri);
        when(
          client.post(successUri, headers: headers, body: json.encode(body)),
        ).thenAnswer(
          (_) async => http.Response(response.missingRequiredKey, 200),
        );

        expect(
          () async => service.inviteAFriend(email),
          throwsA(isA<MissingRequiredKeysException>()),
        );
        reset(client);
      });
    });
    group('check', () {
      const code = 'someCode';

      test('A [LokalInvite] should be returned when successful', () async {
        when(api.authHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.invite,
            pathSegments: ['check', code],
          ),
        ).thenReturn(successUri);
        when(
          client.get(successUri, headers: headers),
        ).thenAnswer((_) async => http.Response(response.check, 200));

        expect(await service.check(code), isA<LokalInvite>());
        reset(client);
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(api.authHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.invite,
            pathSegments: ['check', code],
          ),
        ).thenReturn(unsucessfulUri);
        when(
          client.get(
            unsucessfulUri,
            headers: headers,
          ),
        ).thenAnswer((_) async => http.Response(response.checkError, 400));

        expect(
          () async => service.check(code),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () {
        when(api.authHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.invite,
            pathSegments: ['check', code],
          ),
        ).thenReturn(successUri);
        when(
          client.get(successUri, headers: headers),
        ).thenAnswer(
          (_) async => http.Response(response.missingRequiredKey, 200),
        );

        expect(
          () async => service.check(code),
          throwsA(isA<MissingRequiredKeysException>()),
        );
        reset(client);
      });
    });

    group('claim', () {
      const request = InviteRequest(userId: 'userId', code: 'code');
      test('A value of [true] should be returned when successful', () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(Endpoint.invite, pathSegments: ['claim']),
        ).thenReturn(successUri);

        when(
          client.post(
            successUri,
            headers: headers,
            body: json.encode(request),
          ),
        ).thenAnswer((_) async => http.Response(response.claimOk, 200));

        expect(
          await service.claim(request: request),
          isTrue,
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(Endpoint.invite, pathSegments: ['claim']),
        ).thenReturn(successUri);

        when(
          client.post(
            successUri,
            headers: headers,
            body: json.encode(request),
          ),
        ).thenAnswer((_) async => http.Response(response.claimError, 200));

        expect(
          await service.claim(request: request),
          isFalse,
        );
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(Endpoint.invite, pathSegments: ['claim']),
        ).thenReturn(successUri);

        when(
          client.post(
            successUri,
            headers: headers,
            body: json.encode(request),
          ),
        ).thenAnswer((_) async => http.Response(response.claimError, 400));

        expect(
          () async => service.claim(request: request),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });
  });
}
