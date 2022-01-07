import 'dart:convert';

import '../../models/conversation.dart';
import 'api.dart';
import 'api_service.dart';

class ConversationAPIService extends APIService<Conversation> {
  const ConversationAPIService(this.api);

  final API api;
  Endpoint get endpoint => Endpoint.chat;

  Future<Conversation> createConversation({
    required String chatId,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await poster(
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
    required String chatId,
    required String messageId,
  }) async {
    try {
      final response = await deleter(
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
