import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:lokalapp/models/chat_model.dart';
import 'package:lokalapp/models/failure_exception.dart';
import 'package:lokalapp/models/post_requests/chat/chat_create.request.dart';
import 'package:lokalapp/models/post_requests/chat/chat_invite.request.dart';
import 'package:lokalapp/services/api/api.dart';
import 'package:lokalapp/services/api/chat_api_service.dart';
import 'package:lokalapp/services/api/client/lokal_http_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'chat_api_service_test.mocks.dart';
import 'responses/chat_api_service.responses.dart' as response;

@GenerateMocks([API, LokalHttpClient])
void main() {
  group('[ChatAPIService]', () {
    final api = MockAPI();
    final client = MockLokalHttpClient();
    final service = ChatAPIService(api, client: client);

    final successUri = Uri.parse('https://success.example.com');
    final unsucessfulUri = Uri.parse('https://unsuccessful.example.com');
    const headers = <String, String>{'idToken': 'valid'};

    group('getChatByMembers', () {
      test('A [ChatModel] should be returned when successful', () async {
        const members = ['member1, member2'];
        when(api.authHeader()).thenReturn(headers);
        when(
          api.baseUri(
            pathSegments: const ['getChatByMemberIds'],
            queryParameters: <String, List<String>>{'memberIds': members},
          ),
        ).thenReturn(successUri);

        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.successResponse, 200),
        );

        expect(
          await service.getChatByMembers(members: members),
          isA<ChatModel>(),
        );
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        const members = ['member1, member2'];
        when(api.authHeader()).thenReturn(headers);
        when(
          api.baseUri(
            pathSegments: const ['getChatByMemberIds'],
            queryParameters: <String, List<String>>{'memberIds': members},
          ),
        ).thenReturn(unsucessfulUri);

        when(client.get(unsucessfulUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.errorResponse, 400),
        );

        expect(
          () async => service.getChatByMembers(members: members),
          throwsA(isA<FailureException>()),
        );
      });

      test(
          'A TypeError should be thrown when the returned '
          'json data is incomplete', () async {
        const members = ['member1, member2'];
        when(api.authHeader()).thenReturn(headers);
        when(
          api.baseUri(
            pathSegments: const ['getChatByMemberIds'],
            queryParameters: <String, List<String>>{'memberIds': members},
          ),
        ).thenReturn(successUri);

        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.errorResponse, 200),
        );

        expect(
          () async => service.getChatByMembers(members: members),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('createChat', () {
      final request = ChatCreateRequest(
        members: ['member1, member2'],
        message: 'Hello!',
      );
      test('A [ChatModel] should be returned when successful', () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(api.endpointUri(Endpoint.chat)).thenReturn(successUri);
        when(
          client.post(
            successUri,
            headers: headers,
            body: json.encode(request.toJson()),
          ),
        ).thenAnswer((_) async => http.Response(response.successResponse, 200));

        expect(await service.createChat(request: request), isA<ChatModel>());
      });
      test('A [FailureException] should be thrown when unsuccessful', () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(api.endpointUri(Endpoint.chat)).thenReturn(unsucessfulUri);
        when(
          client.post(
            unsucessfulUri,
            headers: headers,
            body: json.encode(request.toJson()),
          ),
        ).thenAnswer((_) async => http.Response(response.errorResponse, 400));

        expect(
          () async => service.createChat(request: request),
          throwsA(isA<FailureException>()),
        );
      });

      test(
        'A [MissingRequiredKeysException] should be thrown when returned '
        'payload is missing required fields',
        () {
          when(api.withBodyHeader()).thenReturn(headers);
          when(api.endpointUri(Endpoint.chat)).thenReturn(successUri);
          when(
            client.post(
              successUri,
              headers: headers,
              body: json.encode(request.toJson()),
            ),
          ).thenAnswer(
            (_) async => http.Response(response.missingKeyResponse, 200),
          );

          expect(
            () async => service.createChat(request: request),
            throwsA(isA<MissingRequiredKeysException>()),
          );
        },
      );

      test(
        'A [FailureException] should be thrown when there is no payload with a '
        'status 200 response.',
        () async {
          when(api.withBodyHeader()).thenReturn(headers);
          when(api.endpointUri(Endpoint.chat)).thenReturn(successUri);
          when(
            client.post(
              successUri,
              headers: headers,
              body: json.encode(request.toJson()),
            ),
          ).thenAnswer(
            (_) async => http.Response('', 200),
          );

          expect(
            () async => service.createChat(request: request),
            throwsA(isA<FailureException>()),
          );
        },
      );
    });

    group('updateTitle', () {
      const chatId = 'chatId';
      const title = 'title';

      test('A value of [true] should be returned when successful', () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(Endpoint.chat, pathSegments: [chatId, 'updateTitle']),
        ).thenReturn(successUri);

        when(
          client.put(
            successUri,
            headers: headers,
            body: json.encode({'title': title}),
          ),
        ).thenAnswer((_) async => http.Response(response.okStatus, 200));

        expect(
          await service.updateTitle(chatId: chatId, title: title),
          isTrue,
        );
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(Endpoint.chat, pathSegments: [chatId, 'updateTitle']),
        ).thenReturn(successUri);

        when(
          client.put(
            successUri,
            headers: headers,
            body: json.encode({'title': title}),
          ),
        ).thenAnswer((_) async => http.Response(response.errorStatus, 200));

        expect(
          await service.updateTitle(chatId: chatId, title: title),
          isFalse,
        );
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(Endpoint.chat, pathSegments: [chatId, 'updateTitle']),
        ).thenReturn(successUri);

        when(
          client.put(
            successUri,
            headers: headers,
            body: json.encode({'title': title}),
          ),
        ).thenAnswer((_) async => http.Response(response.errorStatus, 400));

        expect(
          () async => service.updateTitle(chatId: chatId, title: title),
          throwsA(isA<FailureException>()),
        );
      });
    });

    group('inviteUser', () {
      const chatId = 'chatId';
      final request = ChatInviteRequest(
        userId: 'userId',
        newMembers: ['newMember'],
      );

      test('A value of [true] should be returned when successful', () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(api.endpointUri(Endpoint.chat, pathSegments: [chatId, 'invite']))
            .thenReturn(successUri);
        when(
          client.put(
            successUri,
            headers: headers,
            body: json.encode(request.toJson()),
          ),
        ).thenAnswer((_) async => http.Response(response.okStatus, 200));

        expect(
          await service.inviteUser(chatId: chatId, request: request),
          isTrue,
        );
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(Endpoint.chat, pathSegments: [chatId, 'invite']),
        ).thenReturn(successUri);

        when(
          client.put(
            successUri,
            headers: headers,
            body: json.encode(request.toJson()),
          ),
        ).thenAnswer((_) async => http.Response(response.errorStatus, 200));

        expect(
          await service.inviteUser(chatId: chatId, request: request),
          isFalse,
        );
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(Endpoint.chat, pathSegments: [chatId, 'invite']),
        ).thenReturn(successUri);

        when(
          client.put(
            successUri,
            headers: headers,
            body: json.encode(request.toJson()),
          ),
        ).thenAnswer((_) async => http.Response(response.errorStatus, 400));

        expect(
          () async => service.inviteUser(chatId: chatId, request: request),
          throwsA(isA<FailureException>()),
        );
      });
    });

    group('removeUser', () {
      const chatId = 'chatId';
      const userId = 'userId';

      test('A value of [true] should be returned when successful', () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(Endpoint.chat, pathSegments: [chatId, 'removeUser']),
        ).thenReturn(successUri);

        when(
          client.put(
            successUri,
            headers: headers,
            body: json.encode({'user_id': userId}),
          ),
        ).thenAnswer((_) async => http.Response(response.okStatus, 200));

        expect(
          await service.removeUser(chatId: chatId, userId: userId),
          isTrue,
        );
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(Endpoint.chat, pathSegments: [chatId, 'removeUser']),
        ).thenReturn(successUri);

        when(
          client.put(
            successUri,
            headers: headers,
            body: json.encode({'user_id': userId}),
          ),
        ).thenAnswer((_) async => http.Response(response.errorStatus, 200));

        expect(
          await service.removeUser(chatId: chatId, userId: userId),
          isFalse,
        );
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(Endpoint.chat, pathSegments: [chatId, 'removeUser']),
        ).thenReturn(successUri);

        when(
          client.put(
            successUri,
            headers: headers,
            body: json.encode({'user_id': userId}),
          ),
        ).thenAnswer((_) async => http.Response(response.errorStatus, 400));

        expect(
          () async => service.removeUser(chatId: chatId, userId: userId),
          throwsA(isA<FailureException>()),
        );
      });
    });
  });
}
