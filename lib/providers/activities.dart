import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../models/activity_feed.dart';
import '../models/post_requests/activities/activity.request.dart';
import '../models/post_requests/activities/comment.request.dart';
import '../services/api/activity_api_service.dart';
import '../services/api/api.dart';
import '../services/api/comment_api_service.dart';
import '../services/database/collections/activities.collection.dart';
import '../services/database/database.dart';

class Activities extends ChangeNotifier {
  factory Activities(API api, Database database) {
    final _activityService = ActivityAPIService(api);
    final _commentService = CommentsAPIService(api);

    return Activities._(_activityService, _commentService, database.activities);
  }

  Activities._(this._activityService, this._commentService, this._db);

  final ActivityAPIService _activityService;
  final CommentsAPIService _commentService;
  final ActivitiesCollection _db;

  List<ActivityFeed> _feed = [];
  UnmodifiableListView<ActivityFeed> get feed =>
      UnmodifiableListView(_feed.where((a) => !a.archived));

  Stream<List<ActivityFeed>>? _activityStream;
  Stream<List<ActivityFeed>>? get stream => _activityStream;
  StreamSubscription<List<ActivityFeed>>? _activitiesSubscription;
  StreamSubscription<List<ActivityFeed>>? get subscriptionListener =>
      _activitiesSubscription;

  String? _communityId;
  String? get communityId => _communityId;

  String? _userId;
  String? get userId => _userId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @override
  void dispose() {
    _activitiesSubscription?.cancel();
    super.dispose();
  }

  Future<void> setUserCredentials({String? userId, String? communityId}) async {
    if (_communityId == communityId && _userId == userId) return;
    _communityId = communityId;
    _userId = userId;

    if (_communityId == null || _userId == null) {
      _activitiesSubscription?.cancel();
      _feed = [];
      if (hasListeners) notifyListeners();
      return;
    }

    if (communityId != null) {
      _isLoading = true;
      notifyListeners();
      _activityStream = _db.getCommunityFeed(communityId);
      _activitiesSubscription?.cancel();
      _activitiesSubscription = _activityStream?.listen(_subscriptionListener);
    }
  }

  Future<void> _subscriptionListener(List<ActivityFeed> feed) async {
    final _feed = <ActivityFeed>[];
    for (final _activity in feed) {
      final _index = this._feed.indexWhere((a) => a.id == _activity.id);
      if (_index >= 0 && this._feed[_index] == _activity) {
        _feed.add(_activity);
        continue;
      }

      final _isLiked = await _db.isActivityLiked(_activity.id, _userId!);
      final a = _activity.copyWith(liked: _isLiked);
      _feed.add(a);
    }

    if (_feed.equals(this._feed) && _isLoading == false) {
      return;
    }

    this._feed = _feed;
    _isLoading = false;

    if (hasListeners) notifyListeners();
  }

  ActivityFeed? findById(String id) {
    final index = _feed.indexWhere((a) => a.id == id);
    return _feed[index];
  }

  List<ActivityFeed> findByUser(String? userId) {
    return feed.where((activity) => activity.userId == userId).toList();
  }

  Future<void> likePost({
    required String activityId,
    required String userId,
  }) async {
    final index = _feed.indexWhere((a) => a.id == activityId);
    try {
      _feed[index].liked = true;
      _feed[index].likedCount++;
      notifyListeners();

      await _activityService.like(
        activityId: activityId,
        userId: userId,
      );
    } catch (e) {
      _feed[index].liked = false;
      _feed[index].likedCount--;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> unlikePost({
    required String activityId,
    required String userId,
  }) async {
    final index = _feed.indexWhere((a) => a.id == activityId);
    try {
      _feed[index].liked = false;
      _feed[index].likedCount--;
      notifyListeners();
      await _activityService.unlike(
        activityId: activityId,
        userId: userId,
      );
    } catch (e) {
      _feed[index].liked = true;
      _feed[index].likedCount++;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> likeComment({
    required String activityId,
    required String commentId,
    required String userId,
  }) async {
    try {
      await _commentService.like(
        activityId: activityId,
        commentId: commentId,
        userId: userId,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unlikeComment({
    required String activityId,
    required String commentId,
    required String userId,
  }) async {
    try {
      await _commentService.unlike(
        activityId: activityId,
        commentId: commentId,
        userId: userId,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createComment({
    required String activityId,
    required CommentRequest request,
  }) async {
    try {
      await _commentService.create(
        activityId: activityId,
        request: request,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> post(ActivityRequest request) async {
    try {
      await _activityService.create(request: request);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteActivity(String activityId) async {
    final index = _feed.indexWhere((a) => a.id == activityId);
    _feed[index].archived = true;
    notifyListeners();
    try {
      await _activityService.delete(activityId: activityId);
    } catch (e) {
      _feed[index].archived = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> deleteComment({
    required String activityId,
    required String commentId,
  }) {
    try {
      return _commentService.delete(
        activityId: activityId,
        commentId: commentId,
      );
    } catch (e) {
      rethrow;
    }
  }
}
