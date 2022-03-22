import 'dart:convert';

import '../../models/lokal_user.dart';
import '../../models/post_requests/user/user_create.request.dart';
import '../../models/post_requests/user/user_update.request.dart';
import 'api.dart';
import 'api_service.dart';
import 'client/lokal_http_client.dart';

class UserAPIService extends APIService<LokalUser> {
  UserAPIService(this.api, {LokalHttpClient? client})
      : super(client: client ?? LokalHttpClient());

  final API api;
  Endpoint get endpoint => Endpoint.user;

  // --POST
  Future<LokalUser> create({required UserCreateRequest request}) async {
    try {
      final response = await client.post(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(request.toJson())),
      );

      return handleResponse((map) => LokalUser.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  // --GET
  Future<LokalUser> getById({
    required String userId,
  }) async {
    try {
      final response = await client.get(
        api.endpointUri(endpoint, pathSegments: [userId]),
        headers: api.authHeader(),
      );

      return handleResponse((map) => LokalUser.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LokalUser>> getCommunityUsers({
    required String communityId,
  }) async {
    try {
      final response = await client.get(
        api.endpointUri(
          Endpoint.community,
          pathSegments: [communityId, 'users'],
        ),
        headers: api.authHeader(),
      );

      return handleResponseList((map) => LokalUser.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  // --PUT
  Future<bool> update({
    required UserUpdateRequest request,
    required String userId,
  }) async {
    try {
      final response = await client.put(
        api.endpointUri(endpoint, pathSegments: [userId]),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(request.toJson())),
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
      final response = await client.put(
        api.endpointUri(
          endpoint,
          pathSegments: [userId, 'toggleNotificationSetting'],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(body)),
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
      final response = await client.put(
        api.endpointUri(
          endpoint,
          pathSegments: [userId, 'chatSettings'],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(body)),
      );
      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> registerUser({
    required String userId,
    required Map<String, String> body,
  }) async {
    try {
      final response = await client.put(
        api.endpointUri(
          endpoint,
          pathSegments: [userId, 'register'],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(body)),
      );
      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // --DELETE
  Future<bool> delete({required String userId, required String idToken}) async {
    try {
      final response = await client.delete(
        api.endpointUri(endpoint, pathSegments: [userId]),
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }
}
