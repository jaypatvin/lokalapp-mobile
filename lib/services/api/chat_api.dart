import 'dart:convert';

import '../../app/app.locator.dart';
import '../../models/chat_model.dart';
import '../../models/post_requests/chat/chat_create.request.dart';
import '../../models/post_requests/chat/chat_invite.request.dart';
import '../api_service.dart';
import 'api.dart';
import 'client/lokal_http_client.dart';

class ChatAPI {
  Endpoint get endpoint => Endpoint.chat;

  final APIService api = locator<APIService>();
  final client = locator<LokalHttpClient>();

  //#region --GET
  Future<ChatModel> getChatByMembers({required List<String> members}) async {
    try {
      final response = await client.get(
        api.baseUri(
          pathSegments: const ['getChatByMemberIds'],
          queryParameters: <String, List<String>>{
            'memberIds': [...members]
          },
        ),
        headers: api.authHeader(),
      );

      return handleResponse((map) => ChatModel.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }
  //#endregion

  //#region --POST
  Future<ChatModel> createChat({required ChatCreateRequest request}) async {
    try {
      final response = await client.post(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(request.toJson())),
      );

      return handleResponse((map) => ChatModel.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  //#endregion

  //#region -- PUT
  Future<bool> updateTitle({
    required String chatId,
    required String title,
  }) async {
    try {
      final response = await client.put(
        api.endpointUri(
          endpoint,
          pathSegments: [
            chatId,
            'updateTitle',
          ],
        ),
        headers: api.withBodyHeader(),
        body: json.encode({'title': title}),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> inviteUser({
    required String chatId,
    required ChatInviteRequest request,
  }) async {
    try {
      final response = await client.put(
        api.endpointUri(endpoint, pathSegments: [chatId, 'invite']),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(request.toJson())),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> removeUser({
    required String chatId,
    required String userId,
  }) async {
    try {
      final response = await client.put(
        api.endpointUri(endpoint, pathSegments: [chatId, 'removeUser']),
        headers: api.withBodyHeader(),
        body: json.encode({'user_id': userId}),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }
  //#endregion
}
