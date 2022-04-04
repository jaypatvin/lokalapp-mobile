import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:lokalapp/models/failure_exception.dart';
import 'package:lokalapp/models/lokal_user.dart';
import 'package:lokalapp/models/post_requests/user/user_create.request.dart';
import 'package:lokalapp/models/post_requests/user/user_update.request.dart';
import 'package:lokalapp/services/api/api.dart';
import 'package:lokalapp/services/api/client/lokal_http_client.dart';
import 'package:lokalapp/services/api/user_api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'responses/user_api_service.responses.dart' as response;
import 'user_api_service_test.mocks.dart';

@GenerateMocks([API, LokalHttpClient])
void main() {
  group('UserAPIService', () {
    final api = MockAPI();
    final client = MockLokalHttpClient();
    final service = UserAPIService(api, client: client);

    final uri = Uri.parse('https://success.example.com');
    const headers = <String, String>{'idToken': 'valid'};

    group('create', () {
      const request = UserCreateRequest(
        firstName: 'firstName',
        lastName: 'lastName',
        street: 'street',
        communityId: 'communityId',
        email: 'email',
        displayName: 'displayName',
      );

      when(api.withBodyHeader()).thenReturn(headers);
      when(api.endpointUri(Endpoint.user)).thenReturn(uri);

      test('A [LokalUser] should be returned when successful', () async {
        when(client.post(uri, headers: headers, body: json.encode(request)))
            .thenAnswer((_) async => http.Response(response.user, 200));

        expect(
          await service.create(request: request),
          isA<LokalUser>(),
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
            () async => service.create(request: request),
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
          () async => service.create(request: request),
          throwsA(isA<MissingRequiredKeysException>()),
        );
        reset(client);
      });
    });

    group('getById', () {
      const userId = 'userId';

      when(api.authHeader()).thenReturn(headers);
      when(api.endpointUri(Endpoint.user, pathSegments: [userId]))
          .thenReturn(uri);

      test('A [LokalUser] should be returned when successful', () async {
        when(client.get(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.user, 200));

        expect(
          await service.getById(userId: userId),
          isA<LokalUser>(),
        );
        reset(client);
      });

      test(
        'A [FailureException] should be thrown when unsuccessful',
        () {
          when(
            client.get(uri, headers: headers),
          ).thenAnswer((_) async => http.Response(response.error, 400));

          expect(
            () async => service.getById(userId: userId),
            throwsA(isA<FailureException>()),
          );
          reset(client);
        },
      );

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () {
        when(
          client.get(uri, headers: headers),
        ).thenAnswer((_) async => http.Response(response.missingKeys, 200));

        expect(
          () async => service.getById(userId: userId),
          throwsA(isA<MissingRequiredKeysException>()),
        );
        reset(client);
      });
    });

    group('getCommunityUsers', () {
      const communityId = 'communityId';

      when(
        api.endpointUri(
          Endpoint.community,
          pathSegments: [communityId, 'users'],
        ),
      ).thenReturn(uri);
      when(api.authHeader()).thenReturn(headers);

      test('A [List<Shop>] should be returned when successful', () async {
        when(client.get(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.list, 200));
        expect(
          await service.getCommunityUsers(communityId: communityId),
          isA<List<LokalUser>>(),
        );
        reset(client);
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(client.get(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));
        expect(
          () async => service.getCommunityUsers(communityId: communityId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () {
        when(client.get(uri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.missingKeysList, 200),
        );
        expect(
          () async => service.getCommunityUsers(communityId: communityId),
          throwsA(isA<MissingRequiredKeysException>()),
        );
        reset(client);
      });
    });

    group('update', () {
      const request = UserUpdateRequest(firstName: 'someName');
      const userId = 'userId';

      when(api.endpointUri(Endpoint.user, pathSegments: [userId]))
          .thenReturn(uri);
      when(api.withBodyHeader()).thenReturn(headers);

      test('A value of [true] should be returned when successful', () async {
        when(client.put(uri, headers: headers, body: json.encode(request)))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.update(userId: userId, request: request),
          isTrue,
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.put(uri, headers: headers, body: json.encode(request)))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.update(userId: userId, request: request),
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
          () async => service.update(userId: userId, request: request),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('updateNotificationSettings', () {
      const body = <String, bool>{'someUpdate': true};
      const userId = 'userId';

      when(
        api.endpointUri(
          Endpoint.user,
          pathSegments: [userId, 'toggleNotificationSetting'],
        ),
      ).thenReturn(uri);
      when(api.withBodyHeader()).thenReturn(headers);

      test('A value of [true] should be returned when successful', () async {
        when(client.put(uri, headers: headers, body: json.encode(body)))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.updateNotficationSettings(userId: userId, body: body),
          isTrue,
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.put(uri, headers: headers, body: json.encode(body)))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.updateNotficationSettings(userId: userId, body: body),
          isFalse,
        );
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(client.put(uri, headers: headers, body: json.encode(body)))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async =>
              service.updateNotficationSettings(userId: userId, body: body),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('updateChatSettings', () {
      const body = <String, bool>{'someUpdate': true};
      const userId = 'userId';

      when(
        api.endpointUri(
          Endpoint.user,
          pathSegments: [userId, 'chatSettings'],
        ),
      ).thenReturn(uri);
      when(api.withBodyHeader()).thenReturn(headers);

      test('A value of [true] should be returned when successful', () async {
        when(client.put(uri, headers: headers, body: json.encode(body)))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.updateChatSettings(userId: userId, body: body),
          isTrue,
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.put(uri, headers: headers, body: json.encode(body)))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.updateChatSettings(userId: userId, body: body),
          isFalse,
        );
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(client.put(uri, headers: headers, body: json.encode(body)))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.updateChatSettings(userId: userId, body: body),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('updateNotificationSettings', () {
      const body = <String, bool>{'someUpdate': true};
      const userId = 'userId';

      when(
        api.endpointUri(
          Endpoint.user,
          pathSegments: [userId, 'toggleNotificationSetting'],
        ),
      ).thenReturn(uri);
      when(api.withBodyHeader()).thenReturn(headers);

      test('A value of [true] should be returned when successful', () async {
        when(client.put(uri, headers: headers, body: json.encode(body)))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.updateNotficationSettings(userId: userId, body: body),
          isTrue,
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.put(uri, headers: headers, body: json.encode(body)))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.updateNotficationSettings(userId: userId, body: body),
          isFalse,
        );
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(client.put(uri, headers: headers, body: json.encode(body)))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async =>
              service.updateNotficationSettings(userId: userId, body: body),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('registerUser', () {
      const body = <String, String>{'someUpdate': 'update!'};
      const userId = 'userId';

      when(
        api.endpointUri(
          Endpoint.user,
          pathSegments: [userId, 'register'],
        ),
      ).thenReturn(uri);
      when(api.withBodyHeader()).thenReturn(headers);

      test('A value of [true] should be returned when successful', () async {
        when(client.put(uri, headers: headers, body: json.encode(body)))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.registerUser(userId: userId, body: body),
          isTrue,
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.put(uri, headers: headers, body: json.encode(body)))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.registerUser(userId: userId, body: body),
          isFalse,
        );
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(client.put(uri, headers: headers, body: json.encode(body)))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.registerUser(userId: userId, body: body),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('updateNotificationSettings', () {
      const body = <String, bool>{'someUpdate': true};
      const userId = 'userId';

      when(
        api.endpointUri(
          Endpoint.user,
          pathSegments: [userId, 'toggleNotificationSetting'],
        ),
      ).thenReturn(uri);
      when(api.withBodyHeader()).thenReturn(headers);

      test('A value of [true] should be returned when successful', () async {
        when(client.put(uri, headers: headers, body: json.encode(body)))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.updateNotficationSettings(userId: userId, body: body),
          isTrue,
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.put(uri, headers: headers, body: json.encode(body)))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.updateNotficationSettings(userId: userId, body: body),
          isFalse,
        );
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(client.put(uri, headers: headers, body: json.encode(body)))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async =>
              service.updateNotficationSettings(userId: userId, body: body),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('delete', () {
      const userId = 'userId';

      when(
        api.endpointUri(
          Endpoint.user,
          pathSegments: [userId],
        ),
      ).thenReturn(uri);
      when(api.authHeader()).thenReturn(headers);

      test('A value of [true] should be returned when successful', () async {
        when(client.delete(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.ok, 200));

        expect(
          await service.delete(userId: userId),
          isTrue,
        );
        reset(client);
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(client.delete(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.delete(userId: userId),
          isFalse,
        );
        reset(client);
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(client.delete(uri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async => service.delete(userId: userId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });
  });
}
