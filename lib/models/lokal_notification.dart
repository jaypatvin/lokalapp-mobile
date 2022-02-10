import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'timestamp_time_object.dart';

// this will only be used with Firestore database
class LokalNotification {
  const LokalNotification({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    required this.message,
    required this.associatedCollection,
    this.associatedDocument,
    this.associatedDocuments,
    this.image,
    required this.viewed,
    this.dateViewed,
    required this.opened,
    this.dateOpened,
    required this.unread,
    required this.archived,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String type;
  final String title;
  final String? subtitle;
  final String message;
  final String associatedCollection;
  final String? associatedDocument;
  final List<String>? associatedDocuments;
  final String? image;
  final bool viewed;
  final DateTime? dateViewed;
  final bool opened;
  final DateTime? dateOpened;
  final bool unread;
  final bool archived;
  final DateTime createdAt;
  final DateTime? updatedAt;

  LokalNotification copyWith({
    String? id,
    String? type,
    String? title,
    String? subtitle,
    String? message,
    String? associatedCollection,
    String? associatedDocument,
    List<String>? associatedDocuments,
    String? image,
    bool? viewed,
    DateTime? dateViewed,
    bool? opened,
    DateTime? dateOpened,
    bool? unread,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LokalNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      message: message ?? this.message,
      associatedCollection: associatedCollection ?? this.associatedCollection,
      associatedDocument: associatedDocument ?? this.associatedDocument,
      associatedDocuments: associatedDocuments ?? this.associatedDocuments,
      image: image ?? this.image,
      viewed: viewed ?? this.viewed,
      dateViewed: dateViewed ?? this.dateViewed,
      opened: opened ?? this.opened,
      dateOpened: dateOpened ?? this.dateOpened,
      unread: unread ?? this.unread,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'subtitle': subtitle,
      'message': message,
      'associated_collection': associatedCollection,
      'associated_document': associatedDocument,
      'associated_documents': associatedDocuments,
      'image': image,
      'viewed': viewed,
      'date_viewed': dateViewed?.millisecondsSinceEpoch,
      'opened': opened,
      'date_opened': dateOpened?.millisecondsSinceEpoch,
      'unread': unread,
      'archived': archived,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory LokalNotification.fromMap(Map<String, dynamic> map) {
    DateTime? _dateViewed;
    if (map['date_viewed'] != null) {
      _dateViewed = (map['date_viewed'] is Timestamp)
          ? (map['date_viewed'] as Timestamp).toDate()
          : TimestampObject.fromMap(map['date_viewed']).toDateTime();
    }

    DateTime? _dateOpened;
    if (map['date_opened'] != null) {
      _dateOpened = (map['date_opened'] is Timestamp)
          ? (map['date_opened'] as Timestamp).toDate()
          : TimestampObject.fromMap(map['date_opened']).toDateTime();
    }

    final _createdAt = (map['created_at'] is Timestamp)
        ? (map['created_at'] as Timestamp).toDate()
        : TimestampObject.fromMap(map['created_at']).toDateTime();

    DateTime? _udpatedAt;
    if (map['updated_at'] != null) {
      _udpatedAt = (map['updated_at'] is Timestamp)
          ? (map['updated_at'] as Timestamp).toDate()
          : TimestampObject.fromMap(map['updated_at']).toDateTime();
    }

    return LokalNotification(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'],
      message: map['message'] ?? '',
      associatedCollection: map['associated_collection'] ?? '',
      associatedDocument: map['associated_document'],
      associatedDocuments: List<String>.from(map['associated_documents'] ?? []),
      image: map['image'],
      viewed: map['viewed'] ?? false,
      dateViewed: _dateViewed,
      opened: map['opened'] ?? false,
      dateOpened: _dateOpened,
      unread: map['unread'] ?? false,
      archived: map['archived'] ?? false,
      createdAt: _createdAt,
      updatedAt: _udpatedAt,
    );
  }

  factory LokalNotification.fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return LokalNotification.fromMap({'id': doc.id, ...doc.data()});
  }

  String toJson() => json.encode(toMap());

  factory LokalNotification.fromJson(String source) =>
      LokalNotification.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Notification(id: $id, type: $type, title: $title, '
        'subtitle: $subtitle, message: $message, '
        'associatedCollection: $associatedCollection, '
        'associatedDocument: $associatedDocument, '
        'associatedDocuments: $associatedDocuments, image: $image, '
        'viewed: $viewed, dateViewed: $dateViewed, opened: $opened, '
        'dateOpened: $dateOpened, undread: $unread, archived: $archived, '
        'createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LokalNotification &&
        other.id == id &&
        other.type == type &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.message == message &&
        other.associatedCollection == associatedCollection &&
        other.associatedDocument == associatedDocument &&
        listEquals(other.associatedDocuments, associatedDocuments) &&
        other.image == image &&
        other.viewed == viewed &&
        other.dateViewed == dateViewed &&
        other.opened == opened &&
        other.dateOpened == dateOpened &&
        other.unread == unread &&
        other.archived == archived &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        title.hashCode ^
        subtitle.hashCode ^
        message.hashCode ^
        associatedCollection.hashCode ^
        associatedDocument.hashCode ^
        associatedDocuments.hashCode ^
        image.hashCode ^
        viewed.hashCode ^
        dateViewed.hashCode ^
        opened.hashCode ^
        dateOpened.hashCode ^
        unread.hashCode ^
        archived.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
