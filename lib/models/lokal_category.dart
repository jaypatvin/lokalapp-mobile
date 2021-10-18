import 'dart:convert';

import 'status.dart';
import 'timestamp_time_object.dart';

class LokalCategory {
  const LokalCategory({
    required this.id,
    required this.updatedAt,
    required this.archived,
    required this.name,
    required this.createdAt,
    required this.coverUrl,
    required this.iconUrl,
    required this.description,
    required this.status,
  });

  final String id;
  final DateTime? updatedAt;
  final bool archived;
  final String name;
  final DateTime createdAt;
  final String coverUrl;
  final String iconUrl;
  final String description;
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'archived': archived,
      'name': name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'coverUrl': coverUrl,
      'iconUrl': iconUrl,
      'description': description,
      'status': status.value,
    };
  }

  factory LokalCategory.fromMap(Map<String, dynamic> map) {
    return LokalCategory(
      id: map['id'],
      updatedAt: map['updated_at'] != null
          ? TimestampObject.fromMap(map['updated_at']).toDateTime()
          : null,
      archived: map['archived'],
      name: map['name'],
      createdAt: TimestampObject.fromMap(map['created_at']).toDateTime(),
      coverUrl: map['cover_url'],
      iconUrl: map['icon_url'],
      description: map['description'],
      status: map['status'] == Status.enabled.value
          ? Status.enabled
          : Status.disabled,
    );
  }

  String toJson() => json.encode(toMap());

  factory LokalCategory.fromJson(String source) =>
      LokalCategory.fromMap(json.decode(source));

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
