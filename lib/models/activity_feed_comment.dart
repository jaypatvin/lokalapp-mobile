import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'lokal_images.dart';
import 'timestamp_time_object.dart';

class ActivityFeedComment {
  String userId;
  String message;
  List<LokalImages> images;
  TimestampObject createdAt;
  ActivityFeedComment({
    this.userId,
    this.message,
    this.images,
    this.createdAt,
  });

  ActivityFeedComment copyWith({
    String userId,
    String message,
    List<LokalImages> images,
    TimestampObject createdAt,
  }) {
    return ActivityFeedComment(
      userId: userId ?? this.userId,
      message: message ?? this.message,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'message': message,
      'images': images?.map((x) => x.toMap())?.toList(),
      'created_at': createdAt.toMap(),
    };
  }

  factory ActivityFeedComment.fromMap(Map<String, dynamic> map) {
    return ActivityFeedComment(
      userId: map['user_id'],
      message: map['message'],
      images: List<LokalImages>.from(
          map['images']?.map((x) => LokalImages.fromMap(x))),
      createdAt: TimestampObject.fromMap(map['created_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityFeedComment.fromJson(String source) =>
      ActivityFeedComment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ActivityFeedComment(userId: $userId, message: $message, images: $images, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ActivityFeedComment &&
        other.userId == userId &&
        other.message == message &&
        listEquals(other.images, images) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        message.hashCode ^
        images.hashCode ^
        createdAt.hashCode;
  }
}
