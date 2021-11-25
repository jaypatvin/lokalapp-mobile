import 'dart:convert';

import 'address.dart';
import 'timestamp_time_object.dart';

class Community {
  final String id;
  final String name;
  final Address address;
  final String profilePhoto;
  final bool archived;
  final String coverPhoto;
  final DateTime createdAt;
  final DateTime updatedAt;

  Community({
    required this.id,
    required this.name,
    required this.address,
    required this.profilePhoto,
    required this.archived,
    required this.coverPhoto,
    required this.createdAt,
    required this.updatedAt,
  });

  Community copyWith({
    String? id,
    String? name,
    Address? address,
    String? profilePhoto,
    bool? archivedAt,
    String? coverPhoto,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      archived: archivedAt ?? this.archived,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address.toMap(),
      'profilePhoto': profilePhoto,
      'archivedAt': archived,
      'coverPhoto': coverPhoto,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      id: map['id'],
      name: map['name'],
      address: Address.fromMap(map['address']),
      profilePhoto: map['profile_photo'],
      archived: map['archived'],
      coverPhoto: map['cover_photo'],
      createdAt: TimestampObject.fromMap(map['created_at']).toDateTime(),
      updatedAt: TimestampObject.fromMap(map['updated_at']).toDateTime(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Community.fromJson(String source) =>
      Community.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Community(id: $id, name: $name, address: $address, '
        'profilePhoto: $profilePhoto, archivedAt: $archived, '
        'coverPhoto: $coverPhoto, createdAt: $createdAt, '
        'updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Community &&
        other.id == id &&
        other.name == name &&
        other.address == address &&
        other.profilePhoto == profilePhoto &&
        other.archived == archived &&
        other.coverPhoto == coverPhoto &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        address.hashCode ^
        profilePhoto.hashCode ^
        archived.hashCode ^
        coverPhoto.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
