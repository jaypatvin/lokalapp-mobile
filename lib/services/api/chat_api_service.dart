import 'dart:convert';

import '../../models/chat_model.dart';
import 'api.dart';
import 'api_service.dart';

class ChatAPIService extends APIService<ChatModel> {
  const ChatAPIService(this.api);

  final API api;
  Endpoint get endpoint => Endpoint.chat;

  //#region --GET
  Future<ChatModel> getChatByMembers({required List<String> members}) async {
    try {
      final response = await getter(
        api.baseUri(
          pathSegments: const ['getChatByMemberIds'],
          queryParameters: <String, List<String>>{
            'memberIds': [...members]
          },
        ),
        headers: api.authHeader(),
      );

      return handleResponse((map) => ChatModel.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }
  //#endregion

  //#region --POST
  Future<ChatModel> createChat({required Map<String, dynamic> body}) async {
    try {
      final response = await poster(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(body)),
      );

      return handleResponse((map) => ChatModel.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }

  //#endregion

  //#region -- PUT
  Future<bool> updateTitle({
    required String chatId,
    required Map<String, String> body,
  }) async {
    try {
      final response = await putter(
        api.endpointUri(
          endpoint,
          pathSegments: [
            chatId,
            'updateTitle',
          ],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(body)),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> inviteUser({
    required String chatId,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await putter(
        api.endpointUri(endpoint, pathSegments: [chatId, 'invite']),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(body)),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> removeUser({
    required String chatId,
    required Map<String, String> body,
  }) async {
    try {
      final response = await putter(
        api.endpointUri(endpoint, pathSegments: [chatId, 'removeUser']),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(body)),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }
  //#endregion
}
