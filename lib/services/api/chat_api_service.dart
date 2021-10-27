import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/chat_model.dart';
import 'api.dart';
import 'api_service.dart';

class ChatAPIService extends APIService<ChatModel> {
  const ChatAPIService(this.api);

  final API api;
  final endpoint = Endpoint.chat;

  //#region --GET
  Future<ChatModel> getChatByMembers({required List<String> members}) async {
    final response = await http.get(
      api.baseUri(
        pathSegments: const ['getChatByMemberIds'],
        queryParameters: <String, List<String>>{
          'memberIds': [...members]
        },
      ),
      headers: api.authHeader(),
    );

    return handleResponse((map) => ChatModel.fromMap(map), response);
  }
  //#endregion

  //#region --POST
  Future<ChatModel> createChat({required Map<String, dynamic> body}) async {
    final response = await http.post(
      api.endpointUri(endpoint),
      headers: api.withBodyHeader(),
      body: json.encode(body),
    );

    return handleResponse((map) => ChatModel.fromMap(map), response);
  }

  //#endregion

  //#region -- PUT
  Future<bool> updateTitle({
    required String chatId,
    required Map<String, String> body,
  }) async {
    final response = await http.put(
      api.endpointUri(
        endpoint,
        pathSegments: [
          chatId,
          'updateTitle',
        ],
      ),
      headers: api.withBodyHeader(),
      body: json.encode(body),
    );

    return handleGenericResponse(response);
  }

  Future<bool> inviteUser({
    required String chatId,
    required Map<String, dynamic> body,
  }) async {
    final response = await http.put(
      api.endpointUri(endpoint, pathSegments: [chatId, 'invite']),
      headers: api.withBodyHeader(),
      body: json.encode(body),
    );

    return handleGenericResponse(response);
  }

  Future<bool> removeUser({
    required String chatId,
    required Map<String, String> body,
  }) async {
    final response = await http.put(
      api.endpointUri(endpoint, pathSegments: [chatId, 'removeUser']),
      headers: api.withBodyHeader(),
      body: json.encode(body),
    );

    return handleGenericResponse(response);
  }
  //#endregion
}
