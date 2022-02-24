import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../models/activity_feed.dart';
import '../services/api/activity_api_service.dart';
import '../services/api/api.dart';
import '../services/api/comment_api_service.dart';
import '../services/database.dart';

class Activities extends ChangeNotifier {
  factory Activities(API api) {
    final _activityService = ActivityAPIService(api);
    final _commentService = CommentsAPIService(api);
    return Activities._(_activityService, _commentService);
  }

  Activities._(this._activityService, this._commentService);

  final ActivityAPIService _activityService;
  final CommentsAPIService _commentService;
  final Database _db = Database.instance;

  final List<ActivityFeed> _feed = [];
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
    _communityId = communityId;
    _userId = userId;

    if (_communityId == null || _userId == null) {
      _activitiesSubscription?.cancel();
      _feed.clear();
      if (hasListeners) notifyListeners();
      return;
    }

    if (communityId != null) {
      _isLoading = true;
      notifyListeners();
      _activityStream = _db.getCommunityFeed(communityId).map((event) {
        return event.docs.map((doc) => ActivityFeed.fromDocument(doc)).toList();
      });
      _activitiesSubscription?.cancel();
      _activitiesSubscription = _activityStream?.listen(_subscriptionListener);
    }
  }

  Future<void> _subscriptionListener(List<ActivityFeed> feed) async {
    _isLoading = true;
    if (hasListeners) notifyListeners();

    _feed.clear();
    for (final _activity in feed) {
      _activity.liked = await _db.isActivityLiked(_activity.id, _userId!);
      _feed.add(_activity);
    }

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
    required Map<String, dynamic> body,
  }) async {
    try {
      await _commentService.create(
        activityId: activityId,
        body: body,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> post(Map<String, dynamic> data) async {
    try {
      await _activityService.create(data: data);
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
