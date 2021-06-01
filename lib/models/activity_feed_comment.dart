import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'lokal_images.dart';
import 'timestamp_time_object.dart';

class ActivityFeedComment {
  String id;
  String userId;
  String message;
  List<LokalImages> images;
  DateTime createdAt;
  bool liked;
  ActivityFeedComment({
    this.id,
    this.userId,
    this.message,
    this.images,
    this.createdAt,
    this.liked,
  });

  ActivityFeedComment copyWith({
    String id,
    String userId,
    String message,
    List<LokalImages> images,
    DateTime createdAt,
    bool liked,
  }) {
    return ActivityFeedComment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      liked: liked ?? this.liked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'message': message,
      'images': images?.map((x) => x.toMap())?.toList(),
      'created_at': Timestamp.fromDate(createdAt),
      'liked': liked,
    };
  }

  factory ActivityFeedComment.fromMap(Map<String, dynamic> map) {
    return ActivityFeedComment(
      id: map['id'],
      userId: map['user_id'],
      message: map['message'],
      images: List<LokalImages>.from(
          map['images']?.map((x) => LokalImages.fromMap(x))),
      createdAt: DateTime.fromMicrosecondsSinceEpoch(
          TimestampObject.fromMap(map['created_at']).seconds * 1000000 +
              TimestampObject.fromMap(map['created_at']).nanoseconds ~/ 1000),
      liked: map['liked'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityFeedComment.fromJson(String source) =>
      ActivityFeedComment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ActivityFeedComment(id: $id, userId: $userId, message: $message, images: $images, createdAt: $createdAt, liked: $liked)';
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
        other.liked == liked;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        message.hashCode ^
        images.hashCode ^
        createdAt.hashCode ^
        liked.hashCode;
  }
}
