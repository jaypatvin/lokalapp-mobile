import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/json_converters/date_time_converter.dart';
import 'lokal_images.dart';

part 'activity_feed_comment.freezed.dart';
part 'activity_feed_comment.g.dart';

@freezed
class ActivityFeedComment with _$ActivityFeedComment {
  const factory ActivityFeedComment({
    required String id,
    required String userId,
    @Default('') String message,
    @Default(<LokalImages>[]) List<LokalImages> images,
    @DateTimeConverter() required DateTime createdAt,
    @Default(false) bool liked,
    @Default(false) bool archived,
  }) = _ActivityFeedComment;

  factory ActivityFeedComment.fromJson(Map<String, dynamic> json) =>
      _$ActivityFeedCommentFromJson(json);

  factory ActivityFeedComment.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final map = snapshot.data()!;
    return ActivityFeedComment.fromJson({'id': snapshot.id, ...map});
  }
}
