import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/functions.utils.dart';
import 'address.dart';
import 'notification_settings.dart';

part 'lokal_user.g.dart';

enum UserStatus { active, suspended, pending, locked }

extension UserStatusExtension on UserStatus {
  String get value {
    switch (this) {
      case UserStatus.active:
        return 'active';
      case UserStatus.locked:
        return 'locked';
      case UserStatus.pending:
        return 'pending';
      case UserStatus.suspended:
        return 'suspended';
    }
  }
}

@JsonSerializable()
class UserRegistrationStatus {
  @JsonKey(required: true)
  final String idPhoto;
  @JsonKey(required: true)
  final String idType;
  @JsonKey(required: true)
  final String notes;
  @JsonKey(required: true)
  final int step;
  @JsonKey(required: true)
  final bool verified;

  UserRegistrationStatus({
    required this.idPhoto,
    required this.idType,
    required this.notes,
    required this.step,
    required this.verified,
  });

  Map<String, dynamic> toJson() => _$UserRegistrationStatusToJson(this);

  factory UserRegistrationStatus.fromJson(Map<String, dynamic> json) =>
      _$UserRegistrationStatusFromJson(json);

  UserRegistrationStatus copyWith({
    String? idPhoto,
    String? idType,
    String? notes,
    int? step,
    bool? verified,
  }) {
    return UserRegistrationStatus(
      idPhoto: idPhoto ?? this.idPhoto,
      idType: idType ?? this.idType,
      notes: notes ?? this.notes,
      step: step ?? this.step,
      verified: verified ?? this.verified,
    );
  }

  @override
  String toString() {
    return 'UserRegistrationStatus(idPhoto: $idPhoto, idType: $idType, '
        'notes: $notes, step: $step, verified: $verified)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserRegistrationStatus &&
        other.idPhoto == idPhoto &&
        other.idType == idType &&
        other.notes == notes &&
        other.step == step &&
        other.verified == verified;
  }

  @override
  int get hashCode {
    return idPhoto.hashCode ^
        idType.hashCode ^
        notes.hashCode ^
        step.hashCode ^
        verified.hashCode;
  }
}

@JsonSerializable()
class UserRoles {
  const UserRoles({
    required this.member,
    required this.admin,
    this.editor,
  });

  @JsonKey(required: true)
  final bool member;
  @JsonKey(required: true)
  final bool admin;
  final bool? editor;

  Map<String, dynamic> toJson() => _$UserRolesToJson(this);

  factory UserRoles.fromJson(Map<String, dynamic> json) =>
      _$UserRolesFromJson(json);

  UserRoles copyWith({
    bool? member,
    bool? admin,
    bool? editor,
  }) {
    return UserRoles(
      member: member ?? this.member,
      admin: admin ?? this.admin,
      editor: editor ?? this.editor,
    );
  }

  @override
  String toString() =>
      'UserRoles(member: $member, admin: $admin, editor: $editor)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserRoles &&
        other.member == member &&
        other.admin == admin &&
        other.editor == editor;
  }

  @override
  int get hashCode => member.hashCode ^ admin.hashCode ^ editor.hashCode;
}

@JsonSerializable()
class LokalUser {
  const LokalUser({
    required this.id,
    required this.address,
    required this.archived,
    required this.communityId,
    required this.createdAt,
    required this.displayName,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.registration,
    required this.roles,
    required this.status,
    required this.userUids,
    required this.birthdate,
    this.notificationSettings = const NotificationSettings(),
    this.showReadReceipts = false,
    this.profilePhoto,
  });

  @JsonKey(required: true)
  final String id;
  @JsonKey(required: true)
  final Address address;
  @JsonKey(required: true)
  final bool archived;
  @JsonKey(required: true)
  final String birthdate;
  @JsonKey(required: true)
  final String communityId;
  @JsonKey(
    required: true,
    fromJson: createdAtFromJson,
    toJson: nullableDateTimeToString,
  )
  final DateTime createdAt;
  @JsonKey(required: true)
  final String displayName;
  @JsonKey(required: true)
  final String email;
  @JsonKey(required: true)
  final String firstName;
  @JsonKey(required: true)
  final String lastName;
  final NotificationSettings notificationSettings;
  final String? profilePhoto;
  @JsonKey(required: true)
  final UserRegistrationStatus registration;
  @JsonKey(required: true)
  final UserRoles roles;
  @JsonKey(
    required: true,
    fromJson: _userStatusFromJson,
    toJson: _userStatusToJson,
  )
  final UserStatus status;
  @JsonKey(readValue: _showReadReceiptsFromMap)
  final bool showReadReceipts;
  @JsonKey(required: true)
  final List<String> userUids;

  Map<String, dynamic> toJson() => _$LokalUserToJson(this);

  factory LokalUser.fromJson(Map<String, dynamic> json) =>
      _$LokalUserFromJson(json);

  factory LokalUser.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return LokalUser.fromJson({'id': doc.id, ...doc.data()!});
  }

  LokalUser copyWith({
    String? id,
    Address? address,
    bool? archived,
    String? birthdate,
    String? communityId,
    DateTime? createdAt,
    String? displayName,
    String? email,
    String? firstName,
    String? lastName,
    NotificationSettings? notificationSettings,
    String? profilePhoto,
    UserRegistrationStatus? registration,
    UserRoles? roles,
    UserStatus? status,
    bool? showReadReceipts,
    List<String>? userUids,
  }) {
    return LokalUser(
      id: id ?? this.id,
      address: address ?? this.address,
      archived: archived ?? this.archived,
      birthdate: birthdate ?? this.birthdate,
      communityId: communityId ?? this.communityId,
      createdAt: createdAt ?? this.createdAt,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      registration: registration ?? this.registration,
      roles: roles ?? this.roles,
      status: status ?? this.status,
      showReadReceipts: showReadReceipts ?? this.showReadReceipts,
      userUids: userUids ?? this.userUids,
    );
  }

  @override
  String toString() {
    return 'LokalUser(id: $id, address: $address, archived: $archived, '
        'birthDate: $birthdate, communityId: $communityId, '
        'createdAt: $createdAt, displayName: $displayName, '
        'email: $email, firstName: $firstName, lastName: $lastName, '
        'notificationSettings: $notificationSettings, '
        'profilePhoto: $profilePhoto, registration: $registration, '
        'roles: $roles, status: $status, showReadReceipts: $showReadReceipts, '
        'userUids: $userUids)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LokalUser &&
        other.id == id &&
        other.address == address &&
        other.archived == archived &&
        other.birthdate == birthdate &&
        other.communityId == communityId &&
        other.createdAt == createdAt &&
        other.displayName == displayName &&
        other.email == email &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.notificationSettings == notificationSettings &&
        other.profilePhoto == profilePhoto &&
        other.registration == registration &&
        other.roles == roles &&
        other.status == status &&
        other.showReadReceipts == showReadReceipts &&
        listEquals(other.userUids, userUids);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        address.hashCode ^
        archived.hashCode ^
        birthdate.hashCode ^
        communityId.hashCode ^
        createdAt.hashCode ^
        displayName.hashCode ^
        email.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        notificationSettings.hashCode ^
        profilePhoto.hashCode ^
        registration.hashCode ^
        roles.hashCode ^
        status.hashCode ^
        showReadReceipts.hashCode ^
        userUids.hashCode;
  }
}

UserStatus _userStatusFromJson(String status) {
  for (final userStatus in UserStatus.values) {
    if (status == userStatus.value) return userStatus;
  }
  return UserStatus.pending;
}

String _userStatusToJson(UserStatus status) => status.value;

bool? _showReadReceiptsFromMap(Map<dynamic, dynamic> map, String key) {
  return map['chat_settings']?[key] ?? false;
}
