import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/functions.utils.dart';
import 'address.dart';

part 'community.g.dart';

@JsonSerializable()
class Community {
  @JsonKey(required: true)
  final String id;
  @JsonKey(required: true)
  final String name;
  @JsonKey(required: true)
  final Address address;
  @JsonKey(defaultValue: '')
  final String profilePhoto;
  @JsonKey(defaultValue: false)
  final bool archived;
  @JsonKey(required: true)
  final String coverPhoto;
  @JsonKey(
    required: true,
    fromJson: createdAtFromJson,
    toJson: nullableDateTimeToString,
  )
  final DateTime createdAt;
  @JsonKey(
    fromJson: nullableDateTimeFromJson,
    toJson: nullableDateTimeToString,
  )
  final DateTime? updatedAt;

  Community({
    required this.id,
    required this.name,
    required this.address,
    required this.profilePhoto,
    required this.archived,
    required this.coverPhoto,
    required this.createdAt,
    this.updatedAt,
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
      archived: archivedAt ?? archived,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => _$CommunityToJson(this);

  factory Community.fromJson(Map<String, dynamic> json) =>
      _$CommunityFromJson(json);

  factory Community.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Community.fromJson({'id': doc.id, ...doc.data()!});
  }

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
