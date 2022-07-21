import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/functions.utils.dart';
import 'status.dart';

part 'lokal_category.g.dart';

@JsonSerializable()
class LokalCategory {
  const LokalCategory({
    required this.id,
    required this.archived,
    required this.name,
    required this.createdAt,
    required this.coverUrl,
    required this.iconUrl,
    required this.description,
    required this.status,
    this.updatedAt,
  });

  @JsonKey(required: true)
  final String id;
  @JsonKey(
    fromJson: nullableDateTimeFromJson,
    toJson: nullableDateTimeToString,
  )
  final DateTime? updatedAt;
  @JsonKey(required: true, defaultValue: false)
  final bool archived;
  @JsonKey(required: true)
  final String name;
  @JsonKey(
    required: true,
    fromJson: dateTimeFromJson,
    toJson: nullableDateTimeToString,
  )
  final DateTime createdAt;
  @JsonKey(required: true)
  final String coverUrl;
  @JsonKey(required: true)
  final String iconUrl;
  @JsonKey(required: true)
  final String description;
  @JsonKey(required: true, toJson: statusToJson, fromJson: statusFromJson)
  final Status status;

  LokalCategory copyWith({
    String? id,
    DateTime? updatedAt,
    bool? archived,
    String? name,
    DateTime? createdAt,
    String? coverUrl,
    String? iconUrl,
    String? description,
    Status? status,
  }) {
    return LokalCategory(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      archived: archived ?? this.archived,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      coverUrl: coverUrl ?? this.coverUrl,
      iconUrl: iconUrl ?? this.iconUrl,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => _$LokalCategoryToJson(this);

  factory LokalCategory.fromJson(Map<String, dynamic> json) =>
      _$LokalCategoryFromJson(json);

  factory LokalCategory.fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) =>
      LokalCategory.fromJson({'id': doc.id, ...doc.data()});

  @override
  String toString() {
    return 'Category(id: $id, updatedAt: $updatedAt, archived: $archived, '
        'name: $name, createdAt: $createdAt, coverUrl: $coverUrl, '
        'iconUrl: $iconUrl, description: $description, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LokalCategory &&
        other.id == id &&
        other.updatedAt == updatedAt &&
        other.archived == archived &&
        other.name == name &&
        other.createdAt == createdAt &&
        other.coverUrl == coverUrl &&
        other.iconUrl == iconUrl &&
        other.description == description &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        updatedAt.hashCode ^
        archived.hashCode ^
        name.hashCode ^
        createdAt.hashCode ^
        coverUrl.hashCode ^
        iconUrl.hashCode ^
        description.hashCode ^
        status.hashCode;
  }
}
