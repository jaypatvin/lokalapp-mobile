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
    final activityService = ActivityAPIService(api);
    final commentService = CommentsAPIService(api);

    return Activities._(activityService, commentService, database.activities);
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

  Future<void> _subscriptionListener(List<ActivityFeed> dbFeed) async {
    final feed = <ActivityFeed>[];
    for (final activity in dbFeed) {
      final index = _feed.indexWhere((a) => a.id == activity.id);
      if (index >= 0 && _feed[index] == activity) {
        feed.add(activity);
        continue;
      }

      final isLiked = await _db.isActivityLiked(activity.id, _userId!);
      final a = activity.copyWith(liked: isLiked);
      feed.add(a);
    }

    if (feed.equals(_feed) && _isLoading == false) {
      return;
    }

    _feed = feed;
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
    final post = _feed[index];
    try {
      _feed[index] =
          post.copyWith(liked: true, likedCount: post.likedCount + 1);
      notifyListeners();

      await _activityService.like(
        activityId: activityId,
        userId: userId,
      );
    } catch (e) {
      _feed[index] =
          post.copyWith(liked: false, likedCount: post.likedCount - 1);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> unlikePost({
    required String activityId,
    required String userId,
  }) async {
    final index = _feed.indexWhere((a) => a.id == activityId);
    final post = _feed[index];
    try {
      _feed[index] =
          post.copyWith(liked: false, likedCount: post.likedCount - 1);
      notifyListeners();
      await _activityService.unlike(
        activityId: activityId,
        userId: userId,
      );
    } catch (e) {
      _feed[index] =
          post.copyWith(liked: true, likedCount: post.likedCount + 1);
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
    _feed[index] = _feed[index].copyWith(archived: true);
    notifyListeners();
    try {
      await _activityService.delete(activityId: activityId);
    } catch (e) {
      _feed[index] = _feed[index].copyWith(archived: false);
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
