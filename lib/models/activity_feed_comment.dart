import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/functions.utils.dart';
import 'lokal_images.dart';

part 'activity_feed_comment.g.dart';

@JsonSerializable()
class ActivityFeedComment {
  ActivityFeedComment({
    required this.id,
    required this.userId,
    required this.message,
    required this.images,
    required this.createdAt,
    required this.liked,
    required this.archived,
  });

  @JsonKey(required: true)
  String id;
  @JsonKey(required: true)
  String userId;
  @JsonKey(defaultValue: '')
  String message;

  @JsonKey(defaultValue: <LokalImages>[])
  List<LokalImages> images;

  @JsonKey(fromJson: createdAtFromJson, toJson: nullableDateTimeToString)
  DateTime createdAt;

  @JsonKey(defaultValue: false)
  bool archived;

  @JsonKey(defaultValue: false)
  bool liked;

  ActivityFeedComment copyWith({
    String? id,
    String? userId,
    String? message,
    List<LokalImages>? images,
    DateTime? createdAt,
    bool? archived,
    bool? liked,
  }) {
    return ActivityFeedComment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      archived: archived ?? this.archived,
      liked: liked ?? this.liked,
    );
  }

  factory ActivityFeedComment.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final map = snapshot.data()!;
    return ActivityFeedComment.fromJson({'id': snapshot.id, ...map});
  }

  Map<String, dynamic> toJson() => _$ActivityFeedCommentToJson(this);

  factory ActivityFeedComment.fromJson(Map<String, dynamic> json) =>
      _$ActivityFeedCommentFromJson(json);

  @override
  String toString() {
    return 'ActivityFeedComment(id: $id, userId: $userId, message: $message, '
        'images: $images, createdAt: $createdAt, archived: $archived '
        'liked: $liked)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ActivityFeedComment &&
        other.id == id &&
        other.userId == userId &&
        other.message == message &&
        listEquals(other.images, images) &&
        other.createdAt == createdAt &&
        other.archived == archived &&
        other.liked == liked;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        message.hashCode ^
        images.hashCode ^
        createdAt.hashCode ^
        archived.hashCode ^
        liked.hashCode;
  }
}
