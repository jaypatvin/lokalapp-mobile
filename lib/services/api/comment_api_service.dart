import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/activity_feed_comment.dart';
import 'api.dart';
import 'api_service.dart';

class CommentsAPIService extends APIService<ActivityFeedComment> {
  const CommentsAPIService(this.api);

  final API api;
  final endpoint = Endpoint.activity;

  //#region -- GET
  Future<ActivityFeedComment> getById({
    required String activityId,
    required String commentId,
  }) async {
    final response = await http.get(
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
  }

  Future<List<ActivityFeedComment>> getActivityComments(
      {required String activityId}) async {
    final response = await http.get(
      api.endpointUri(endpoint, pathSegments: [activityId, 'comments']),
      headers: api.authHeader(),
    );

    return handleResponseList(
      (map) => ActivityFeedComment.fromMap(map),
      response,
    );
  }

  Future<List<ActivityFeedComment>> getUserComments({
    required String userId,
  }) async {
    final response = await http.get(
      api.endpointUri(Endpoint.user, pathSegments: [userId, 'comments']),
      headers: api.authHeader(),
    );

    return handleResponseList(
      (map) => ActivityFeedComment.fromMap(map),
      response,
    );
  }
  //#endregion

  //#region --POST
  Future<ActivityFeedComment> create({
    required String activityId,
    required Map<String, dynamic> body,
  }) async {
    final response = await http.post(
      api.endpointUri(endpoint, pathSegments: [activityId, 'comments']),
      headers: api.withBodyHeader(),
      body: json.encode(body),
    );

    return handleResponse(
      (map) => ActivityFeedComment.fromMap(map),
      response,
    );
  }

  Future<bool> like({
    required String activityId,
    required String commentId,
    required String userId,
  }) async {
    final response = await http.post(
      api.endpointUri(
        endpoint,
        pathSegments: [activityId, 'comments', commentId, 'like'],
      ),
      headers: api.withBodyHeader(),
      body: json.encode({'user_id': userId}),
    );

    return handleGenericResponse(response);
  }
  //#endregion

  //#region --PUT
  Future<bool> update({
    required String activityId,
    required String commentId,
    required Map<String, dynamic> body,
  }) async {
    final response = await http.post(
      api.endpointUri(
        endpoint,
        pathSegments: [activityId, 'comments', commentId],
      ),
      headers: api.withBodyHeader(),
      body: json.encode(body),
    );

    return handleGenericResponse(response);
  }
  //#endregion

  //#region --DELETE
  Future<bool> delete({
    required String activityId,
    required String commentId,
  }) async {
    final response = await http.delete(
      api.endpointUri(
        endpoint,
        pathSegments: [activityId, 'comments', commentId],
      ),
      headers: api.authHeader(),
    );

    return handleGenericResponse(response);
  }

  Future<bool> unlike({
    required String activityId,
    required String commentId,
    required String userId,
  }) async {
    final response = await http.delete(
      api.endpointUri(
        endpoint,
        pathSegments: [activityId, 'comments', commentId, 'unlike'],
      ),
      headers: api.withBodyHeader(),
      body: json.encode({"user_id": userId}),
    );

    return handleGenericResponse(response);
  }
  //#endregion
}
