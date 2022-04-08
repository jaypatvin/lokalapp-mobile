import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lokalapp/models/failure_exception.dart';
import 'package:lokalapp/models/post_requests/chat/conversation.request.dart';
import 'package:lokalapp/services/api/api.dart';
import 'package:lokalapp/services/api/client/lokal_http_client.dart';
import 'package:lokalapp/services/api/conversation_api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'conversation_api_service_test.mocks.dart';
import 'responses/conversation_api_service.responses.dart' as response;

@GenerateMocks([API, LokalHttpClient])
void main() {
  group('ConversationAPIService', () {
    final api = MockAPI();
    final client = MockLokalHttpClient();
    final service = ConversationAPIService(api, client: client);

    final successUri = Uri.parse('https://success.example.com');
    final unsucessfulUri = Uri.parse('https://unsuccessful.example.com');
    const headers = <String, String>{'idToken': 'valid'};
    const chatId = 'chatId';

    group('createConversation', () {
      final request = ConversationRequest(userId: 'userId', message: 'hello');
      test('A value of [true] should be returned when successful', () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.chat,
            pathSegments: [chatId, 'conversation'],
          ),
        ).thenReturn(successUri);
        when(
          client.post(successUri, headers: headers, body: json.encode(request)),
        ).thenAnswer((_) async => http.Response(response.success, 200));

        expect(
          await service.createConversation(chatId: chatId, request: request),
          isTrue,
        );
        reset(client);
      });

      test(
          'A value of [false] should be returned when unsuccessful with a '
          'status code of 200', () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.chat,
            pathSegments: [chatId, 'conversation'],
          ),
        ).thenReturn(successUri);
        when(
          client.post(successUri, headers: headers, body: json.encode(request)),
        ).thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.createConversation(chatId: chatId, request: request),
          isFalse,
        );
        reset(client);
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.chat,
            pathSegments: [chatId, 'conversation'],
          ),
        ).thenReturn(unsucessfulUri);
        when(
          client.post(
            unsucessfulUri,
            headers: headers,
            body: json.encode(request),
          ),
        ).thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async =>
              service.createConversation(chatId: chatId, request: request),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });

    group('deleteConversation', () {
      const chatId = 'chatId';
      const messageId = 'messageId';

      test('A value of [true] should be returned when successful', () async {
        when(api.authHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.chat,
            pathSegments: [chatId, 'conversation', messageId],
          ),
        ).thenReturn(successUri);
        when(client.delete(successUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.success, 200));

        expect(
          await service.deleteConversation(
            chatId: chatId,
            messageId: messageId,
          ),
          isTrue,
        );
        reset(client);
      });

      test(
          'A value of [false] should be returned when unsuccessful with a '
          'status code of 200', () async {
        when(api.authHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.chat,
            pathSegments: [chatId, 'conversation', messageId],
          ),
        ).thenReturn(successUri);
        when(client.delete(successUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 200));

        expect(
          await service.deleteConversation(
            chatId: chatId,
            messageId: messageId,
          ),
          isFalse,
        );
        reset(client);
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(api.authHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.chat,
            pathSegments: [chatId, 'conversation', messageId],
          ),
        ).thenReturn(unsucessfulUri);
        when(client.delete(unsucessfulUri, headers: headers))
            .thenAnswer((_) async => http.Response(response.error, 400));

        expect(
          () async =>
              service.deleteConversation(chatId: chatId, messageId: messageId),
          throwsA(isA<FailureException>()),
        );
        reset(client);
      });
    });
  });
}
