import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'lokal_api_constants.dart';

class CommentsService {
  static CommentsService _instance;
  static CommentsService get instance {
    if (_instance == null) {
      _instance = CommentsService();
    }
    return _instance;
  }

  // --GET
  Future<http.Response> getById(
      String activityId, String commentId, String idToken) async {
    return await http.get("$activitiesUrl/$activityId/comments/$commentId",
        headers: {"Authorization": "Bearer $idToken"});
  }

  Future<http.Response> getActivityComments(
      {@required String activityId, @required String idToken}) async {
    return await http.get("$activitiesUrl/$activityId/comments",
        headers: {"Authorization": "Bearer $idToken"});
  }

  Future<http.Response> getUserComments(
      {@required String userId, @required String idToken}) async {
    return await http.get("$usersUrl/$userId/comments",
        headers: {"Authorization": "Bearer $idToken"});
  }

// --POST
  Future<http.Response> create(
      {@required activityId,
      @required String idToken,
      @required Map data}) async {
    var body = json.encode(data);
    var response = await http.post('$activitiesUrl/$activityId/comments',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken"
        },
        body: body);

    return response;
  }

// --DELETE
  Future<http.Response> delete(
      {@required activityId, @required commentId, @required idToken}) async {
    return await http.delete('$activitiesUrl/$activityId/comments/$commentId',
        headers: {"Authorization": "Bearer $idToken"});
  }

// --PUT
  Future<http.Response> update(
      {@required String activityId,
      @required commentId,
      @required String idToken,
      @required Map data}) async {
    var body = json.encode(data);
    return await http.put('$activitiesUrl/$activityId',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken"
        },
        body: body);
  }
}
