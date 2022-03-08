import 'dart:convert';

import '../../models/activity_feed_comment.dart';
import 'api.dart';
import 'api_service.dart';

class CommentsAPIService extends APIService<ActivityFeedComment> {
  const CommentsAPIService(this.api);

  final API api;
  Endpoint get endpoint => Endpoint.activity;

  //#region -- GET
  Future<ActivityFeedComment> getById({
    required String activityId,
    required String commentId,
  }) async {
    try {
      final response = await getter(
        api.endpointUri(
          endpoint,
          pathSegments: [activityId, 'comments', commentId],
        ),
        headers: api.authHeader(),
      );

      return handleResponse(
        (map) => ActivityFeedComment.fromMap(map),
        response,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ActivityFeedComment>> getActivityComments({
    required String activityId,
  }) async {
    try {
      final response = await getter(
        api.endpointUri(endpoint, pathSegments: [activityId, 'comments']),
        headers: api.authHeader(),
      );

      return handleResponseList(
        (map) => ActivityFeedComment.fromMap(map),
        response,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ActivityFeedComment>> getUserComments({
    required String userId,
  }) async {
    try {
      final response = await getter(
        api.endpointUri(Endpoint.user, pathSegments: [userId, 'comments']),
        headers: api.authHeader(),
      );

      return handleResponseList(
        (map) => ActivityFeedComment.fromMap(map),
        response,
      );
    } catch (e) {
      rethrow;
    }
  }
  //#endregion

  //#region --POST
  Future<ActivityFeedComment> create({
    required String activityId,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await poster(
        api.endpointUri(endpoint, pathSegments: [activityId, 'comments']),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(body)),
      );

      return handleResponse(
        (map) => ActivityFeedComment.fromMap(map),
        response,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> like({
    required String activityId,
    required String commentId,
    required String userId,
  }) async {
    try {
      final response = await poster(
        api.endpointUri(
          endpoint,
          pathSegments: [activityId, 'comments', commentId, 'like'],
        ),
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
    required String commentId,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await poster(
        api.endpointUri(
          endpoint,
          pathSegments: [activityId, 'comments', commentId],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(body)),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }
  //#endregion

  //#region --DELETE
  Future<bool> delete({
    required String activityId,
    required String commentId,
  }) async {
    try {
      final response = await deleter(
        api.endpointUri(
          endpoint,
          pathSegments: [activityId, 'comments', commentId],
        ),
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> unlike({
    required String activityId,
    required String commentId,
    required String userId,
  }) async {
    try {
      final response = await deleter(
        api.endpointUri(
          endpoint,
          pathSegments: [activityId, 'comments', commentId, 'unlike'],
        ),
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
