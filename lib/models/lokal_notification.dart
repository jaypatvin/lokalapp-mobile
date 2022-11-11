import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/json_converters/date_time_converter.dart';

part 'lokal_notification.freezed.dart';
part 'lokal_notification.g.dart';

// this will only be used with Firestore database
@freezed
class LokalNotification with _$LokalNotification {
  const factory LokalNotification({
    required String id,
    required String type,
    required String title,
    String? subtitle,
    required String message,
    required String associatedCollection,
    String? associatedDocument,
    List<String>? associatedDocuments,
    String? image,
    required bool viewed,
    @DateTimeOrNullConverter() DateTime? dateOpened,
    required bool unread,
    required bool archived,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeOrNullConverter() DateTime? updatedAt,
  }) = _LokalNotification;

  factory LokalNotification.fromJson(Map<String, dynamic> json) =>
      _$LokalNotificationFromJson(json);

  factory LokalNotification.fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return LokalNotification.fromJson({'id': doc.id, ...doc.data()});
  }
}

// @JsonSerializable()
// class LokalNotification {
//   const LokalNotification({
//     required this.id,
//     required this.type,
//     required this.title,
//     this.subtitle,
//     required this.message,
//     required this.associatedCollection,
//     this.associatedDocument,
//     this.associatedDocuments,
//     this.image,
//     required this.viewed,
//     this.dateViewed,
//     required this.opened,
//     this.dateOpened,
//     required this.unread,
//     required this.archived,
//     required this.createdAt,
//     this.updatedAt,
//   });

//   @JsonKey(required: true)
//   final String id;
//   @JsonKey(required: true)
//   final String type;
//   @JsonKey(required: true)
//   final String title;
//   final String? subtitle;
//   @JsonKey(required: true)
//   final String message;
//   @JsonKey(required: true)
//   final String associatedCollection;
//   final String? associatedDocument;
//   final List<String>? associatedDocuments;
//   final String? image;
//   @JsonKey(required: true)
//   final bool viewed;
//   @JsonKey(
//     fromJson: nullableDateTimeFromJson,
//     toJson: nullableDateTimeToString,
//   )
//   final DateTime? dateViewed;
//   @JsonKey(required: true)
//   final bool opened;
//   @JsonKey(
//     fromJson: nullableDateTimeFromJson,
//     toJson: nullableDateTimeToString,
//   )
//   final DateTime? dateOpened;
//   @JsonKey(required: true)
//   final bool unread;
//   @JsonKey(required: true)
//   final bool archived;
//   @JsonKey(
//     required: true,
//     fromJson: dateTimeFromJson,
//     toJson: nullableDateTimeToString,
//   )
//   final DateTime createdAt;
//   @JsonKey(
//     fromJson: nullableDateTimeFromJson,
//     toJson: nullableDateTimeToString,
//   )
//   final DateTime? updatedAt;

//   LokalNotification copyWith({
//     String? id,
//     String? type,
//     String? title,
//     String? subtitle,
//     String? message,
//     String? associatedCollection,
//     String? associatedDocument,
//     List<String>? associatedDocuments,
//     String? image,
//     bool? viewed,
//     DateTime? dateViewed,
//     bool? opened,
//     DateTime? dateOpened,
//     bool? unread,
//     bool? archived,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) {
//     return LokalNotification(
//       id: id ?? this.id,
//       type: type ?? this.type,
//       title: title ?? this.title,
//       subtitle: subtitle ?? this.subtitle,
//       message: message ?? this.message,
//       associatedCollection: associatedCollection ?? this.associatedCollection,
//       associatedDocument: associatedDocument ?? this.associatedDocument,
//       associatedDocuments: associatedDocuments ?? this.associatedDocuments,
//       image: image ?? this.image,
//       viewed: viewed ?? this.viewed,
//       dateViewed: dateViewed ?? this.dateViewed,
//       opened: opened ?? this.opened,
//       dateOpened: dateOpened ?? this.dateOpened,
//       unread: unread ?? this.unread,
//       archived: archived ?? this.archived,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }

//   factory LokalNotification.fromDocument(
//     QueryDocumentSnapshot<Map<String, dynamic>> doc,
//   ) {
//     return LokalNotification.fromJson({'id': doc.id, ...doc.data()});
//   }

//   Map<String, dynamic> toJson() => _$LokalNotificationToJson(this);

//   factory LokalNotification.fromJson(Map<String, dynamic> json) =>
//       _$LokalNotificationFromJson(json);

//   @override
//   String toString() {
//     return 'Notification(id: $id, type: $type, title: $title, '
//         'subtitle: $subtitle, message: $message, '
//         'associatedCollection: $associatedCollection, '
//         'associatedDocument: $associatedDocument, '
//         'associatedDocuments: $associatedDocuments, image: $image, '
//         'viewed: $viewed, dateViewed: $dateViewed, opened: $opened, '
//         'dateOpened: $dateOpened, undread: $unread, archived: $archived, '
//         'createdAt: $createdAt, updatedAt: $updatedAt)';
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is LokalNotification &&
//         other.id == id &&
//         other.type == type &&
//         other.title == title &&
//         other.subtitle == subtitle &&
//         other.message == message &&
//         other.associatedCollection == associatedCollection &&
//         other.associatedDocument == associatedDocument &&
//         listEquals(other.associatedDocuments, associatedDocuments) &&
//         other.image == image &&
//         other.viewed == viewed &&
//         other.dateViewed == dateViewed &&
//         other.opened == opened &&
//         other.dateOpened == dateOpened &&
//         other.unread == unread &&
//         other.archived == archived &&
//         other.createdAt == createdAt &&
//         other.updatedAt == updatedAt;
//   }

//   @override
//   int get hashCode {
//     return id.hashCode ^
//         type.hashCode ^
//         title.hashCode ^
//         subtitle.hashCode ^
//         message.hashCode ^
//         associatedCollection.hashCode ^
//         associatedDocument.hashCode ^
//         associatedDocuments.hashCode ^
//         image.hashCode ^
//         viewed.hashCode ^
//         dateViewed.hashCode ^
//         opened.hashCode ^
//         dateOpened.hashCode ^
//         unread.hashCode ^
//         archived.hashCode ^
//         createdAt.hashCode ^
//         updatedAt.hashCode;
//   }
// }
