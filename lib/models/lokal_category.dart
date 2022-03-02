import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

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
    final DateTime? _updatedAt;
    final DateTime _createdAt;
    if (map['updated_at'] is Timestamp) {
      _updatedAt = (map['updated_at'] as Timestamp).toDate();
    } else if (map['updated_at'] != null) {
      _updatedAt = TimestampObject.fromMap(map['updated_at']).toDateTime();
    } else {
      _updatedAt = null;
    }

    if (map['created_at'] is Timestamp) {
      _createdAt = (map['created_at'] as Timestamp).toDate();
    } else {
      _createdAt = TimestampObject.fromMap(map['created_at']).toDateTime();
    }

    return LokalCategory(
      id: map['id'],
      updatedAt: _updatedAt,
      archived: map['archived'],
      name: map['name'],
      createdAt: _createdAt,
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

  factory LokalCategory.fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return LokalCategory.fromMap({'id': doc.id, ...doc.data()});
  }

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
