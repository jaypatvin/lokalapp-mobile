import 'dart:convert';

import '../../models/conversation.dart';
import '../../models/post_requests/chat/conversation.request.dart';
import 'api.dart';
import 'api_service.dart';
import 'client/lokal_http_client.dart';

class ConversationAPIService extends APIService<Conversation> {
  ConversationAPIService(this.api, {LokalHttpClient? client})
      : super(client: client ?? LokalHttpClient());

  final API api;
  Endpoint get endpoint => Endpoint.chat;

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
