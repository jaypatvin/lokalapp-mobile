// ignore_for_file: invalid_annotation_target

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/json_converters/date_time_converter.dart';
import 'activity_feed_comment.dart';
import 'lokal_images.dart';

part 'activity_feed.freezed.dart';
part 'activity_feed.g.dart';

@freezed
class ActivityFeed with _$ActivityFeed {
  const factory ActivityFeed({
    required String id,
    required String communityId,
    required String userId,
    @Default('') String message,
    @Default(<LokalImages>[]) List<LokalImages> images,
    @Default(<ActivityFeedComment>[]) List<ActivityFeedComment> comments,
    @Default(false) bool liked,
    @DateTimeConverter() required DateTime createdAt,
    @Default(false) bool archived,
    @Default(0) @JsonKey(readValue: _likedCountReadValue) int likedCount,
    @Default(0) @JsonKey(readValue: _commentCountReadValue) int commentCount,
  }) = _ActivityFeed;

  factory ActivityFeed.fromJson(Map<String, dynamic> json) =>
      _$ActivityFeedFromJson(json);

  factory ActivityFeed.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final map = snapshot.data()!;
    return ActivityFeed.fromJson({'id': snapshot.id, ...map});
  }
}

int? _likedCountReadValue(Map<dynamic, dynamic> map, String key) =>
    map['_meta']?['likes_count'];
int? _commentCountReadValue(Map<dynamic, dynamic> map, String key) =>
    map['_meta']?['comment_count'];
