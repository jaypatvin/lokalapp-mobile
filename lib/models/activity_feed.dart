import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'activity_feed_comment.dart';
import 'lokal_images.dart';
import 'timestamp_time_object.dart';

class ActivityFeed {
  String id;
  String communityId;
  String userId;
  String message;
  List<LokalImages> images;
  List<ActivityFeedComment> comments;
  bool liked;
  DateTime createdAt;
  int likedCount;
  int commentCount;
  bool archived;
  String status;
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'community_id': communityId,
      'user_id': userId,
      'message': message,
      'images': images.map((x) => x.toMap()).toList(),
      'comments': comments.map((x) => x.toMap()).toList(),
      'liked': liked,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  factory ActivityFeed.fromMap(Map<String, dynamic> map) {
    return ActivityFeed(
      id: map['id'] ?? '',
      communityId: map['community_id'] ?? '',
      userId: map['user_id'] ?? '',
      message: map['message'] ?? '',
      images: List<LokalImages>.from(
        map['images']?.map((x) => LokalImages.fromMap(x)) ?? [],
      ),
      liked: map['liked'] ?? false,
      comments: List<ActivityFeedComment>.from(
        map['comments']?.map((x) => ActivityFeedComment.fromMap(map)) ?? [],
      ),
      createdAt: TimestampObject.fromMap(map['created_at']).toDateTime(),
      likedCount: map['_meta']?['likes_count'] ?? 0,
      commentCount: map['_meta']?['comment_count'] ?? 0,
      archived: map['archived'],
      status: map['status'],
    );
  }

  factory ActivityFeed.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final map = snapshot.data()!;
    return ActivityFeed(
      id: snapshot.id,
      communityId: map['community_id'] ?? '',
      userId: map['user_id'] ?? '',
      message: map['message'] ?? '',
      images: List<LokalImages>.from(
        map['images']?.map((x) => LokalImages.fromMap(x)) ?? [],
      ),
      liked: map['liked'] ?? false,
      comments: List<ActivityFeedComment>.from(
        map['comments']?.map((x) => ActivityFeedComment.fromMap(map)) ?? [],
      ),
      createdAt: (map['created_at'] as Timestamp).toDate(),
      likedCount: map['_meta']?['likes_count'] ?? 0,
      commentCount: map['_meta']?['comment_count'] ?? 0,
      archived: map['archived'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityFeed.fromJson(String source) =>
      ActivityFeed.fromMap(json.decode(source));

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
