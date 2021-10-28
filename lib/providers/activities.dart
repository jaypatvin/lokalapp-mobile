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
  Activities._(this._activityService, this._commentService);

  factory Activities(API api) {
    final _activityService = ActivityAPIService(api);
    final _commentService = CommentsAPIService(api);
    return Activities._(_activityService, _commentService);
  }

  final ActivityAPIService _activityService;
  final CommentsAPIService _commentService;
  final Database _db = Database.instance;
  List<ActivityFeed> _feed = [];

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _activityFeedSubscription;

  String _communityId = '';
  bool _isLoading = false;
  bool _isCommentLoading = false;

  UnmodifiableListView<ActivityFeed> get feed => UnmodifiableListView(_feed);
  String get communityId => _communityId;
  bool get isLoading => _isLoading;
  bool get isCommentLoading => _isCommentLoading;

  @override
  void dispose() {
    _activityFeedSubscription?.cancel();
    super.dispose();
  }

  void setCommunityId(String? id) {
    if (id != null) {
      if (id == _communityId) return;
      _communityId = id;
      _activityFeedSubscription?.cancel();
      _activityFeedSubscription =
          _db.getCommunityTimeline(id).listen(_activityFeedListener);
    }
  }

  void _activityFeedListener(QuerySnapshot<Map<String, dynamic>> query) async {
    final length = query.docChanges.length;
    if (_isLoading || length > 1) return;
    for (final change in query.docChanges) {
      final id = change.doc.id;
      final index = _feed.indexWhere((a) => a.id == id);

      if (index >= 0) {
        final _activity = ActivityFeed.fromDocument({
          'id': id,
          ...change.doc.data()!,
        });
        if (_feed[index].likedCount == _activity.likedCount &&
            _feed[index].commentCount == _activity.commentCount) return;

        _feed[index].likedCount = _activity.likedCount;
        _feed[index].commentCount = _activity.commentCount;
        notifyListeners();
        return;
      }

      final activityFeed = await _activityService.getById(activityId: id);
      _feed
        ..add(activityFeed)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    }
  }

  ActivityFeed findById(String id) {
    final index = _feed.indexWhere((a) => a.id == id);
    if (index < 0) throw 'No Product with that Id.';
    return _feed[index];
  }

  List<ActivityFeed> findByUser(String? userId) {
    return _feed.where((activity) => activity.userId == userId).toList();
  }

  Future<void> likePost({
    required String activityId,
    required String userId,
  }) async {
    final feed = this.findById(activityId);
    feed.likedCount++;
    feed.liked = true;
    notifyListeners();

    try {
      await _activityService.like(activityId: activityId, userId: userId);
    } catch (e) {
      feed.likedCount--;
      feed.liked = false;
      notifyListeners();
      throw e;
    }
  }

  Future<void> unlikePost({
    required String activityId,
    required String userId,
  }) async {
    final feed = this.findById(activityId);
    feed.likedCount--;
    feed.liked = false;
    notifyListeners();

    try {
      await _activityService.like(activityId: activityId, userId: userId);
    } catch (e) {
      feed.likedCount++;
      feed.liked = true;
      notifyListeners();
      throw e;
    }
  }

  Future<void> likeComment({
    required String activityId,
    required String commentId,
    required String userId,
  }) async {
    final feed = this.findById(activityId);
    final comment = feed.comments.firstWhere(
      (comment) => comment.id == commentId,
      orElse: () => throw 'Comment does not exist!',
    );
    comment.liked = true;
    notifyListeners();

    try {
      await _commentService.like(
        activityId: activityId,
        commentId: commentId,
        userId: userId,
      );
    } catch (e) {
      comment.liked = false;
      notifyListeners();
      throw e;
    }
  }

  Future<void> unlikeComment({
    required String activityId,
    required String commentId,
    required String userId,
  }) async {
    final feed = this.findById(activityId);
    final comment = feed.comments.firstWhere(
      (comment) => comment.id == commentId,
      orElse: () => throw 'Comment does not exist!',
    );
    comment.liked = false;
    notifyListeners();

    try {
      await _commentService.unlike(
        activityId: activityId,
        commentId: commentId,
        userId: userId,
      );
    } catch (e) {
      comment.liked = true;
      notifyListeners();
      throw e;
    }
  }

  Future<void> createComment({
    required String activityId,
    required Map<String, dynamic> body,
  }) async {
    try {
      final comment = await _commentService.create(
        activityId: activityId,
        body: body,
      );
      this.findById(activityId).comments.add(comment);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchComments({required String activityId}) async {
    _isCommentLoading = true;
    notifyListeners();

    try {
      final comments = await _commentService.getActivityComments(
        activityId: activityId,
      );
      comments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      this.findById(activityId).comments = comments;
      _isCommentLoading = false;
      notifyListeners();
    } catch (e) {
      _isCommentLoading = false;
      notifyListeners();
      throw e;
    }
  }

  Future<void> fetch() async {
    _isLoading = true;
    notifyListeners();

    try {
      final feed = await _activityService.getAll();
      _feed = feed..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  Future<void> post(Map<String, dynamic> data) async {
    try {
      final activity = await _activityService.create(data: data);
      _feed
        ..add(activity)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
