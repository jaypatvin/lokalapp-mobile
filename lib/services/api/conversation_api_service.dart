import 'dart:convert';

import '../../models/conversation.dart';
import '../../models/post_requests/chat/conversation.request.dart';
import 'api.dart';
import 'api_service.dart';

class ConversationAPIService extends APIService<Conversation> {
  const ConversationAPIService(this.api);

  final API api;
  Endpoint get endpoint => Endpoint.chat;

  Future<bool> createConversation({
    required String chatId,
    required ConversationRequest request,
  }) async {
    try {
      final response = await poster(
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
