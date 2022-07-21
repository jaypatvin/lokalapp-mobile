import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/functions.utils.dart';
import 'activity_feed_comment.dart';
import 'lokal_images.dart';

part 'activity_feed.g.dart';

@JsonSerializable()
class ActivityFeed {
  ActivityFeed({
    required this.id,
    required this.communityId,
    required this.userId,
    required this.liked,
    required this.createdAt,
    required this.message,
    required this.images,
    required this.comments,
    required this.archived,
    this.status = 'enabled',
    this.likedCount = 0,
    this.commentCount = 0,
  });

  @JsonKey(required: true)
  String id;
  @JsonKey(required: true)
  String communityId;
  @JsonKey(required: true)
  String userId;
  @JsonKey(defaultValue: '')
  String message;
  @JsonKey(defaultValue: <LokalImages>[])
  List<LokalImages> images;
  @JsonKey(defaultValue: <ActivityFeedComment>[])
  List<ActivityFeedComment> comments;
  @JsonKey(defaultValue: false)
  bool liked;
  @JsonKey(fromJson: dateTimeFromJson, toJson: nullableDateTimeToString)
  DateTime createdAt;
  @JsonKey(defaultValue: false)
  bool archived;
  @JsonKey(readValue: _likedCountReadValue)
  int likedCount;
  @JsonKey(readValue: _commentCountReadValue)
  int commentCount;
  String status;

  ActivityFeed copyWith({
    String? id,
    String? communityId,
    String? userId,
    String? message,
    List<LokalImages>? images,
    List<ActivityFeedComment>? comments,
    bool? liked,
    DateTime? createdAt,
    int? likedCount,
    int? commentCount,
    bool? archived,
    String? status,
  }) {
    return ActivityFeed(
      id: id ?? this.id,
      communityId: communityId ?? this.communityId,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      images: images ?? this.images,
      comments: comments ?? this.comments,
      liked: liked ?? this.liked,
      createdAt: createdAt ?? this.createdAt,
      likedCount: likedCount ?? this.likedCount,
      commentCount: commentCount ?? this.commentCount,
      archived: archived ?? this.archived,
      status: status ?? this.status,
    );
  }

  factory ActivityFeed.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final map = snapshot.data()!;
    return ActivityFeed.fromJson({'id': snapshot.id, ...map});
  }

  Map<String, dynamic> toJson() => _$ActivityFeedToJson(this);

  factory ActivityFeed.fromJson(Map<String, dynamic> json) =>
      _$ActivityFeedFromJson(json);

  @override
  String toString() {
    return 'ActivityFeed(id: $id, communityId: $communityId, userId: $userId, '
        'message: $message, images: $images, comments: $comments, '
        'liked: $liked, createdAt: $createdAt, likedCount: $likedCount, '
        'commentCount: $commentCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ActivityFeed &&
        other.id == id &&
        other.communityId == communityId &&
        other.userId == userId &&
        other.message == message &&
        listEquals(other.images, images) &&
        listEquals(other.comments, comments) &&
        other.liked == liked &&
        other.createdAt == createdAt &&
        other.likedCount == likedCount &&
        other.commentCount == commentCount &&
        other.archived == archived &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        communityId.hashCode ^
        userId.hashCode ^
        message.hashCode ^
        images.hashCode ^
        comments.hashCode ^
        liked.hashCode ^
        createdAt.hashCode ^
        likedCount.hashCode ^
        commentCount.hashCode ^
        archived.hashCode ^
        status.hashCode;
  }
}

int? _likedCountReadValue(Map<dynamic, dynamic> map, String key) =>
    map['_meta']?['likes_count'];
int? _commentCountReadValue(Map<dynamic, dynamic> map, String key) =>
    map['_meta']?['comment_count'];
