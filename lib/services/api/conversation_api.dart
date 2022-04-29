import 'dart:convert';

import '../../app/app.locator.dart';
import '../../models/post_requests/chat/conversation.request.dart';
import '../api_service.dart';
import 'api.dart';
import 'client/lokal_http_client.dart';

class ConversationAPI {
  Endpoint get endpoint => Endpoint.chat;

  final APIService api = locator<APIService>();
  final client = locator<LokalHttpClient>();

  Future<bool> createConversation({
    required String chatId,
    required ConversationRequest request,
  }) async {
    try {
      final response = await client.post(
        api.endpointUri(
          endpoint,
          pathSegments: [chatId, 'conversation'],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(request.toJson())),
      );

      // Let firebase handle the creation of the conversation.
      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteConversation({
    required String chatId,
    required String messageId,
  }) async {
    try {
      final response = await client.delete(
        api.endpointUri(
          endpoint,
          pathSegments: [
            chatId,
            'conversation',
            messageId,
          ],
        ),
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }
}
