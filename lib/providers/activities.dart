import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/activity_feed.dart';
import '../models/activity_feed_comment.dart';
import '../services/lokal_api_service.dart';

class Activities extends ChangeNotifier {
  String _communityId;
  List<ActivityFeed> _feed = [];
  bool _isLoading = false;
  bool _isCommentLoading = false;

  bool get isLoading => _isLoading;
  bool get isCommentLoading => _isCommentLoading;
  List<ActivityFeed> get feed {
    return [..._feed];
  }

  String get communityId => _communityId;
  //set communityId(String communityId) => this._communityId = communityId;
  //
  void setCommunityId(String id) {
    _communityId = id;
  }

  ActivityFeed findById(String id) {
    return _feed.firstWhere((activity) => activity.id == id);
  }

  List<ActivityFeed> findByUser(String userId) {
    return _feed.where((activity) => activity.userId == userId).toList();
  }

  Future<bool> likePost({
    @required String authToken,
    @required String activityId,
    @required String userId,
  }) async {
    var response = await LokalApiService.instance.activity.like(
      idToken: authToken,
      activityId: activityId,
      userId: userId,
    );

    if (response.statusCode != 200) {
      return false;
    }
    var data = json.decode(response.body);
    if (data['status'] == 'ok') {
      var feed = _feed.where((feed) => feed.id == activityId).first;
      feed.likedCount++;
      feed.liked = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> unlikePost({
    @required String authToken,
    @required String activityId,
    @required String userId,
  }) async {
    var response = await LokalApiService.instance.activity.unlike(
      idToken: authToken,
      activityId: activityId,
      userId: userId,
    );

    if (response.statusCode != 200) {
      return false;
    }
    var data = json.decode(response.body);
    if (data['status'] == 'ok') {
      var feed = _feed.where((feed) => feed.id == activityId).first;
      feed.likedCount--;
      feed.liked = false;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> likeComment({
    @required String authToken,
    @required String commentId,
    @required String activityId,
    @required String userId,
  }) async {
    var response = await LokalApiService.instance.comment.like(
      idToken: authToken,
      activityId: activityId,
      userId: userId,
      commentId: commentId,
    );

    if (response.statusCode != 200) {
      return false;
    }
    var data = json.decode(response.body);
    if (data['status'] == 'ok') {
      var feed = _feed.where((feed) => feed.id == activityId).first;
      var comment =
          feed.comments.where((comment) => comment.id == commentId).first;
      comment.liked = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> unlikeComment({
    @required String authToken,
    @required String commentId,
    @required String activityId,
    @required String userId,
  }) async {
    var response = await LokalApiService.instance.comment.unlike(
      idToken: authToken,
      activityId: activityId,
      userId: userId,
      commentId: commentId,
    );

    if (response.statusCode != 200) {
      return false;
    }
    var data = json.decode(response.body);
    if (data['status'] == 'ok') {
      var feed = _feed.where((feed) => feed.id == activityId).first;
      var comment =
          feed.comments.where((comment) => comment.id == commentId).first;
      comment.liked = false;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> createComment({
    @required String authToken,
    @required String activityId,
    @required Map body,
  }) async {
    try {
      var response = await LokalApiService.instance.comment.create(
        activityId: activityId,
        idToken: authToken,
        data: body,
      );

      if (response.statusCode != 200) {
        return false;
      }
      var data = json.decode(response.body);
      if (data['status'] == 'ok') {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> fetchComments({
    @required String authToken,
    @required String activityId,
  }) async {
    _isCommentLoading = true;
    try {
      var response = await LokalApiService.instance.comment
          .getActivityComments(activityId: activityId, idToken: authToken);

      if (response.statusCode != 200) {
        _isCommentLoading = false;
        notifyListeners();
        return;
      }

      var data = json.decode(response.body);

      if (data['status'] == 'ok') {
        List<ActivityFeedComment> comments = [];
        for (var comment in data['data']) {
          var _comment = ActivityFeedComment.fromMap(comment);
          comments.add(_comment);
        }
        comments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        _feed.firstWhere((feed) => feed.id == activityId)..comments = comments;
      }
      _isCommentLoading = false;
    } catch (e) {
      _isCommentLoading = false;
    }
    notifyListeners();
  }

  Future<void> fetch(String authToken) async {
    _isLoading = true;
    try {
      var response = await LokalApiService.instance.activity
          .getCommunityActivities(communityId: communityId, idToken: authToken);

      if (response.statusCode != 200) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      var data = json.decode(response.body);

      if (data['status'] == 'ok') {
        List<ActivityFeed> activities = [];

        for (var activity in data['data']) {
          var _activity = ActivityFeed.fromMap(activity);
          _activity.comments = [];
          activities.add(_activity);
        }

        _feed = activities..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }

      _isLoading = false;
    } catch (e) {
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<bool> post(String authToken, Map data) async {
    try {
      var response = await LokalApiService.instance.activity
          .create(idToken: authToken, data: data);

      if (response.statusCode != 200) {
        return false;
      }
      var body = json.decode(response.body);
      if (body['status'] == 'ok') {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
