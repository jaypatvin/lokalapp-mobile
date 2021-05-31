import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'lokal_api_constants.dart';

class ActivityFeedService {
  static ActivityFeedService _instance;

  static ActivityFeedService get instance {
    if (_instance == null) {
      _instance = ActivityFeedService();
    }
    return _instance;
  }

  // --GET
  Future<http.Response> getById(
      {@required String activityId, @required String idToken}) async {
    return await http.get("$activitiesUrl/$activityId",
        headers: {"Authorization": "Bearer $idToken"});
  }

  Future<http.Response> getAll({@required String idToken}) async {
    return await http.get("$activitiesUrl/activities",
        headers: {"Authorization": "Bearer $idToken"});
  }

  Future<http.Response> getUserActivities(
      {@required String userId, @required String idToken}) async {
    return await http.get("$usersUrl/$userId/activities",
        headers: {"Authorization": "Bearer $idToken"});
  }

  Future<http.Response> getCommunityActivities(
      {@required String communityId, @required String idToken}) async {
    return await http.get("$communityUrl/$communityId/activities",
        headers: {"Authorization": "Bearer $idToken"});
  }

// --POST
  Future<http.Response> create(
      {@required String idToken, @required Map data}) async {
    var body = json.encode(data);
    var response = await http.post(activitiesUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken"
        },
        body: body);

    return response;
  }

  Future<http.Response> like({
    @required String idToken,
    @required String activityId,
    @required String userId,
  }) async {
    var body = json.encode({"user_id": userId});
    var response = await http.post("$activitiesUrl/$activityId/like",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken"
        },
        body: body);
    return response;
  }

// --DELETE
  Future<http.Response> delete({
    @required activityId,
    @required idToken,
  }) async {
    return await http.delete('$activitiesUrl/$activityId',
        headers: {"Authorization": "Bearer $idToken"});
  }

  Future<http.Response> unlike({
    @required String idToken,
    @required String activityId,
    @required String userId,
  }) async {
    final url = Uri.parse("$activitiesUrl/$activityId/unlike");
    final request = http.Request("DELETE", url);
    request.headers.addAll(<String, String>{
      "Content-Type": "application/json",
      "Authorization": "Bearer $idToken"
    });
    request.body = jsonEncode({"user_id": userId});
    final response = await request.send();
    return await http.Response.fromStream(response);
  }

// --PUT
  Future<http.Response> update(
      {@required String activityId,
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
