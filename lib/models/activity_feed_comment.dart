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
  bool archived;
  bool liked;

  ActivityFeedComment({
    required this.id,
    required this.userId,
    required this.message,
    required this.images,
    required this.createdAt,
    required this.liked,
    required this.archived,
  });

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'message': message,
      'images': images.map((x) => x.toMap()).toList(),
      'created_at': Timestamp.fromDate(createdAt),
      'archived': archived,
      'liked': liked,
    };
  }

  factory ActivityFeedComment.fromMap(Map<String, dynamic> map) {
    return ActivityFeedComment(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      message: map['message'] ?? '',
      images: map['images'] != null
          ? List<LokalImages>.from(
              map['images']?.map((x) => LokalImages.fromMap(x)),
            )
          : const [],
      createdAt: DateTime.fromMicrosecondsSinceEpoch(
        TimestampObject.fromMap(map['created_at']).seconds! * 1000000 +
            TimestampObject.fromMap(map['created_at']).nanoseconds! ~/ 1000,
      ),
      archived: map['archived'] ?? false,
      liked: map['liked'] ?? false,
    );
  }

  factory ActivityFeedComment.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final map = snapshot.data()!;
    return ActivityFeedComment(
      id: snapshot.id,
      userId: map['user_id'] ?? '',
      message: map['message'] ?? '',
      images: List<LokalImages>.from(
        map['images']?.map((x) => LokalImages.fromMap(x)) ?? [],
      ),
      createdAt: (map['created_at'] as Timestamp).toDate(),
      archived: map['archived'] ?? false,
      liked: map['liked'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityFeedComment.fromJson(String source) =>
      ActivityFeedComment.fromMap(json.decode(source));

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
