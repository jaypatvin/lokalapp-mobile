import 'dart:convert';

import '../../models/activity_feed.dart';
import 'api.dart';
import 'api_service.dart';

///
class ActivityAPIService extends APIService<ActivityFeed> {
  const ActivityAPIService(this.api);

  final API api;
  Endpoint get endpoint => Endpoint.activity;

  //#region -- GET
  Future<ActivityFeed> getById({required String activityId}) async {
    try {
      final response = await getter(
        api.endpointUri(endpoint, pathSegments: [activityId]),
        headers: api.authHeader(),
      );

      return handleResponse(
        (map) => ActivityFeed.fromJson(map),
        response,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ActivityFeed>> getAll() async {
    try {
      final response = await getter(
        api.endpointUri(endpoint),
        headers: api.authHeader(),
      );

      return handleResponseList(
        (map) => ActivityFeed.fromJson(map),
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
      final response = await getter(
        uri,
        headers: api.authHeader(),
      );

      return handleResponseList(
        (map) => ActivityFeed.fromJson(map),
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
      final response = await getter(
        uri,
        headers: api.authHeader(),
      );

      return handleResponseList(
        (map) => ActivityFeed.fromJson(map),
        response,
      );
    } catch (e) {
      rethrow;
    }
  }
  //#endregion

  //#region -- POST
  Future<ActivityFeed> create({
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await poster(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(body)),
      );

      return handleResponse(
        (map) => ActivityFeed.fromJson(map),
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
      final response = await poster(
        uri,
        headers: api.withBodyHeader(),
        body: json.encode({'user_id': userId}),
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
      final response = await deleter(
        uri,
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> unlike({
    required String activityId,
    required String userId,
  }) async {
    try {
      final uri =
          api.endpointUri(endpoint, pathSegments: [activityId, 'unlike']);

      final response = await deleter(
        uri,
        headers: api.withBodyHeader(),
        body: json.encode({'user_id': userId}),
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
    required Map<String, dynamic> body,
  }) async {
    try {
      final uri = api.endpointUri(endpoint, pathSegments: [activityId]);

      final response = await putter(
        uri,
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
