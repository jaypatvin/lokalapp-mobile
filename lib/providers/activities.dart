import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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

  late Stream<QuerySnapshot<Map<String, dynamic>>> activityFeed;

  String _communityId = '';
  bool _isLoading = false;
  bool _isCommentLoading = false;

  String get communityId => _communityId;
  bool get isLoading => _isLoading;
  bool get isCommentLoading => _isCommentLoading;

  void setCommunityId(String? id) {
    if (id != null) {
      if (id == _communityId) return;
      _communityId = id;
      activityFeed = _db.getCommunityFeed(id);
    }
  }

  Future<void> likePost({
    required String activityId,
    required String userId,
  }) async {
    try {
      await _activityService.like(activityId: activityId, userId: userId);
    } catch (e) {
      throw e;
    }
  }

  Future<void> unlikePost({
    required String activityId,
    required String userId,
  }) async {
    try {
      await _activityService.unlike(
        activityId: activityId,
        userId: userId,
      );
    } catch (e) {
      throw e;
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
      throw e;
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
      throw e;
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
      throw e;
    }
  }

  Future<void> post(Map<String, dynamic> data) async {
    try {
      await _activityService.create(data: data);
    } catch (e) {
      throw e;
    }
  }
}
