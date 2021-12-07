import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/lokal_user.dart';
import 'api.dart';
import 'api_service.dart';

class UserAPIService extends APIService<LokalUser> {
  const UserAPIService(this.api);

  final API api;
  final Endpoint endpoint = Endpoint.user;

  // --POST
  Future<LokalUser> create({
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await http.post(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: json.encode(body),
      );

      return handleResponse((map) => LokalUser.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }

  // --GET
  Future<LokalUser> getById({
    required String userId,
  }) async {
    try {
      final response = await http.get(
        api.endpointUri(endpoint, pathSegments: [userId]),
        headers: api.authHeader(),
      );

      return handleResponse((map) => LokalUser.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LokalUser>> getCommunityUsers({
    required String communityId,
  }) async {
    try {
      final response = await http.get(
        api.endpointUri(Endpoint.community,
            pathSegments: [communityId, 'users']),
        headers: api.authHeader(),
      );

      return handleResponseList((map) => LokalUser.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }

  // --PUT
  Future<bool> update({
    required Map body,
    required String userId,
  }) async {
    try {
      final response = await http.put(
        api.endpointUri(endpoint, pathSegments: [userId]),
        headers: api.withBodyHeader(),
        body: json.encode(body),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateNotficationSettings({
    required String userId,
    required Map<String, bool> body,
  }) async {
    try {
      final response = await http.put(
        api.endpointUri(
          endpoint,
          pathSegments: [userId, 'toggleNotificationSetting'],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(body),
      );
      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateChatSettings({
    required String userId,
    required Map<String, bool> body,
  }) async {
    try {
      final response = await http.put(
        api.endpointUri(
          endpoint,
          pathSegments: [userId, 'chatSettings'],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(body),
      );
      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // --DELETE
  Future<bool> delete({required String userId, required String idToken}) async {
    try {
      final response = await http.delete(
        api.endpointUri(endpoint, pathSegments: [userId]),
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }
}
