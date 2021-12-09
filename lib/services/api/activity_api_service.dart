import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/activity_feed.dart';
import 'api.dart';
import 'api_service.dart';

///
class ActivityAPIService extends APIService<ActivityFeed> {
  const ActivityAPIService(this.api);

  final API api;
  final Endpoint endpoint = Endpoint.activity;

  //#region -- GET
  Future<ActivityFeed> getById({required String activityId}) async {
    try {
      final response = await http.get(
        api.endpointUri(endpoint, pathSegments: [activityId]),
        headers: api.authHeader(),
      );

      return handleResponse(
        (map) => ActivityFeed.fromMap(map),
        response,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ActivityFeed>> getAll() async {
    try {
      final response = await http.get(
        api.endpointUri(endpoint),
        headers: api.authHeader(),
      );

      return handleResponseList(
        (map) => ActivityFeed.fromMap(map),
        response,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ActivityFeed>> getUserActivities({required String userId}) async {
    try {
      final uri = api.endpointUri(
        Endpoint.user,
        pathSegments: [userId, 'activities'],
      );
      final response = await http.get(
        uri,
        headers: api.authHeader(),
      );

      return handleResponseList(
        (map) => ActivityFeed.fromMap(map),
        response,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ActivityFeed>> getCommunityActivities({
    required String communityId,
  }) async {
    try {
      final uri = api.endpointUri(
        Endpoint.community,
        pathSegments: [communityId, 'activities'],
      );
      final response = await http.get(
        uri,
        headers: api.authHeader(),
      );

      return handleResponseList(
        (map) => ActivityFeed.fromMap(map),
        response,
      );
    } catch (e) {
      rethrow;
    }
  }
  //#endregion

  //#region -- POST
  Future<ActivityFeed> create({
    required Map data,
  }) async {
    try {
      final body = json.encode(data);
      final response = await http.post(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: body,
      );

      return handleResponse(
        (map) => ActivityFeed.fromMap(map),
        response,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> like({
    required String activityId,
    required String userId,
  }) async {
    try {
      final uri = api.endpointUri(
        endpoint,
        pathSegments: [activityId, 'like'],
      );
      final response = await http.post(
        uri,
        headers: api.withBodyHeader(),
        body: json.encode({"user_id": userId}),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }
  //#endregion

  //#region -- DELETE
  Future<bool> delete({required String activityId}) async {
    try {
      final uri = api.endpointUri(endpoint, pathSegments: [activityId]);
      final response = await http.delete(
        uri,
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> unlike({required String activityId, required userId}) async {
    try {
      final uri =
          api.endpointUri(endpoint, pathSegments: [activityId, 'unlike']);

      final response = await http.delete(
        uri,
        headers: api.withBodyHeader(),
        body: jsonEncode({"user_id": userId}),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }
  //#endregion

  //#region --PUT
  Future<bool> update({
    required String activityId,
    required Map<String, dynamic> udpateData,
  }) async {
    try {
      final uri = api.endpointUri(endpoint, pathSegments: [activityId]);

      final response = await http.put(
        uri,
        headers: api.withBodyHeader(),
        body: jsonEncode(udpateData),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }
  //#endregion
}
