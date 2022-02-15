import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  // late Stream<List<ActivityFeed>> activityFeed;
  // StreamSubscription<List<ActivityFeed>>? subscriptionListener;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _snapshotStream;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subscriptionListener;

  final _feedController = StreamController<List<ActivityFeed>>.broadcast();
  Stream<List<ActivityFeed>> get activityFeed => _feedController.stream;

  List<ActivityFeed> _feed = [];
  UnmodifiableListView<ActivityFeed> get feed =>
      UnmodifiableListView(_feed.where((a) => !a.archived));

  String _communityId = '';
  String get communityId => _communityId;

  String _userId = '';
  String get userId => _userId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @override
  void dispose() {
    subscriptionListener?.cancel();
    _feedController.close();
    super.dispose();
  }

  Future<void> setUserCredentials({String? userId, String? communityId}) async {
    if (userId != null && communityId != null) {
      if (communityId == _communityId) return;
      _isLoading = true;
      notifyListeners();
      _communityId = communityId;
      _userId = userId;
      _snapshotStream = _db.getCommunityFeed(communityId);
      await _setActivityFeed();
      subscriptionListener?.cancel();
      subscriptionListener = _snapshotStream.listen(_subscriptionListener);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _subscriptionListener(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (snapshot.docChanges.length == _feed.length) return;
    for (final change in snapshot.docChanges) {
      final doc = change.doc;
      final activity = ActivityFeed.fromDocument(doc);
      final index = _feed.indexWhere((a) => a.id == doc.id);
      activity.liked = await _db.isActivityLiked(activity.id, _userId);

      if (index == -1) {
        _feed.add(activity);
        continue;
      }

      if (_feed[index] == activity) continue;
      _feed[index] = activity;
    }
    _feed.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _feedController.add(_feed);
    notifyListeners();
  }

  Future<void> _setActivityFeed() async {
    final snapshot = await _snapshotStream.first;
    final _feed = <ActivityFeed>[];

    for (final doc in snapshot.docs) {
      final activity = ActivityFeed.fromDocument(doc);
      activity.liked = await _db.isActivityLiked(activity.id, _userId);

      _feed.add(activity);
    }
    _feed.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    this._feed = _feed;
    _feedController.add(this._feed);
  }

  ActivityFeed findById(String id) {
    final index = _feed.indexWhere((a) => a.id == id);
    if (index < 0) throw 'No Activity with that Id.';
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
}
