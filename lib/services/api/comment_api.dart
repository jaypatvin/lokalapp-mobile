import 'dart:convert';

import '../../app/app.locator.dart';
import '../../models/activity_feed_comment.dart';
import '../../models/post_requests/activities/comment.like.request.dart';
import '../../models/post_requests/activities/comment.request.dart';
import '../api_service.dart';
import 'api.dart';
import 'client/lokal_http_client.dart';

class CommentsAPI {
  Endpoint get endpoint => Endpoint.activity;

  final APIService api = locator<APIService>();
  final client = locator<LokalHttpClient>();

  //#region -- GET
  Future<ActivityFeedComment> getById({
    required String activityId,
    required String commentId,
  }) async {
    try {
      final response = await client.get(
        api.endpointUri(
          endpoint,
          pathSegments: [activityId, 'comments', commentId],
        ),
        headers: api.authHeader(),
      );

      return handleResponse(
        (map) => ActivityFeedComment.fromJson(map),
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
      final response = await client.get(
        api.endpointUri(endpoint, pathSegments: [activityId, 'comments']),
        headers: api.authHeader(),
      );

      return handleResponseList(
        (map) => ActivityFeedComment.fromJson(map),
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
      final response = await client.get(
        api.endpointUri(Endpoint.user, pathSegments: [userId, 'comments']),
        headers: api.authHeader(),
      );

      return handleResponseList(
        (map) => ActivityFeedComment.fromJson(map),
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
    required CommentRequest request,
  }) async {
    try {
      final response = await client.post(
        api.endpointUri(endpoint, pathSegments: [activityId, 'comments']),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(request.toJson())),
      );

      return handleResponse(
        (map) => ActivityFeedComment.fromJson(map),
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
      final response = await client.post(
        api.endpointUri(
          endpoint,
          pathSegments: [activityId, 'comments', commentId, 'like'],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(CommentLikeRequest(userId: userId)),
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
    required String message,
  }) async {
    try {
      final response = await client.put(
        api.endpointUri(
          endpoint,
          pathSegments: [activityId, 'comments', commentId],
        ),
        headers: api.withBodyHeader(),
        body: json.encode({'message': message}),
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
      final response = await client.delete(
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
      final response = await client.delete(
        api.endpointUri(
          endpoint,
          pathSegments: [activityId, 'comments', commentId, 'unlike'],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(CommentLikeRequest(userId: userId)),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }
  //#endregion
}
