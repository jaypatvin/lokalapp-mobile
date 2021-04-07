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
  ActivityFeedComment comments;
  List<String> liked;
  DateTime createdAt;
  ActivityFeed({
    this.id,
    this.communityId,
    this.userId,
    this.message,
    this.images,
    this.liked,
    this.createdAt,
  });

  ActivityFeed copyWith({
    String id,
    String communityId,
    String userId,
    String message,
    List<LokalImages> images,
    List<String> liked,
    DateTime createdAt,
  }) {
    return ActivityFeed(
      id: id ?? this.id,
      communityId: communityId ?? this.communityId,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      images: images ?? this.images,
      liked: liked ?? this.liked,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'community_id': communityId,
      'user_id': userId,
      'message': message,
      'images': images?.map((x) => x.toMap())?.toList(),
      'liked': liked,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  factory ActivityFeed.fromMap(Map<String, dynamic> map) {
    return ActivityFeed(
      id: map['id'],
      communityId: map['community_id'],
      userId: map['user_id'],
      message: map['message'],
      images: List<LokalImages>.from(
          map['images']?.map((x) => LokalImages.fromMap(x))),
      liked: map['liked'] == null ? null : List<String>.from(map['liked']),
      createdAt: DateTime.fromMicrosecondsSinceEpoch(
          TimestampObject.fromMap(map['created_at']).seconds * 1000000 +
              TimestampObject.fromMap(map['created_at']).nanoseconds ~/ 1000),
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityFeed.fromJson(String source) =>
      ActivityFeed.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ActivityFeed(id: $id, communityId: $communityId, userId: $userId, message: $message, images: $images, liked: $liked, createdAt: $createdAt)';
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
        listEquals(other.liked, liked) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        communityId.hashCode ^
        userId.hashCode ^
        message.hashCode ^
        images.hashCode ^
        liked.hashCode ^
        createdAt.hashCode;
  }
}
