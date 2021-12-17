import 'dart:convert';

import '../../models/conversation.dart';
import 'api.dart';
import 'api_service.dart';

class ConversationAPIService extends APIService<Conversation> {
  const ConversationAPIService(this.api);

  final API api;
  final Endpoint endpoint = Endpoint.chat;

  Future<Conversation> createConversation({
    required chatId,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await this.poster(
        api.endpointUri(
          endpoint,
          pathSegments: [chatId, 'conversation'],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(body),
      );

      return handleResponse(
        (map) => Conversation.fromMap(map),
        response,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteConversation({
    required chatId,
    required messageId,
  }) async {
    try {
      final response = await this.deleter(
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
