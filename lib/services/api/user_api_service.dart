import 'dart:convert';

import 'package:lokalapp/models/lokal_user.dart';
import 'package:lokalapp/services/api/api.dart';
import 'package:lokalapp/services/api/api_service.dart';
import 'package:http/http.dart' as http;

class UserAPIService extends APIService<LokalUser> {
  const UserAPIService(this.api);

  final API api;
  final Endpoint endpoint = Endpoint.user;

  // --POST
  Future<LokalUser> create({
    required Map<String, dynamic> body,
  }) async {
    final response = await http.post(
      api.endpointUri(endpoint),
      headers: api.withBodyHeader(),
      body: json.encode(body),
    );

    return handleResponse((map) => LokalUser.fromMap(map), response);
  }

  // --GET
  Future<LokalUser> getById({
    required String userId,
  }) async {
    final response = await http.get(
      api.endpointUri(endpoint, pathSegments: [userId]),
      headers: api.authHeader(),
    );

    return handleResponse((map) => LokalUser.fromMap(map), response);
  }

  Future<List<LokalUser>> getCommunityUsers({
    required String communityId,
  }) async {
    final response = await http.get(
      api.endpointUri(Endpoint.community, pathSegments: [communityId, 'users']),
      headers: api.authHeader(),
    );

    return handleResponseList((map) => LokalUser.fromMap(map), response);
  }

  // --PUT
  Future<bool> update({
    required Map body,
    required String userId,
  }) async {
    final response = await http.put(
      api.endpointUri(endpoint, pathSegments: [userId]),
      headers: api.withBodyHeader(),
      body: json.encode(body),
    );

    return handleGenericResponse(response);
  }

  Future<bool> updateNotficationSettings({
    required String userId,
    required Map<String, bool> body,
  }) async {
    final response = await http.put(
      api.endpointUri(
        endpoint,
        pathSegments: [userId, 'toggleNotificationSetting'],
      ),
      headers: api.withBodyHeader(),
      body: json.encode(body),
    );
    return handleGenericResponse(response);
  }

  Future<bool> updateChatSettings({required String userId, required Map<String, bool> body,})async {
    final response = await http.put(
      api.endpointUri(
        endpoint,
        pathSegments: [userId, 'chatSettings'],
      ),
      headers: api.withBodyHeader(),
      body: json.encode(body),
    );
    return handleGenericResponse(response);
  }

  // --DELETE
  Future<bool> delete({required String userId, required String idToken}) async {
    final response = await http.delete(
      api.endpointUri(endpoint, pathSegments: [userId]),
      headers: api.authHeader(),
    );

    return handleGenericResponse(response);
  }
}
