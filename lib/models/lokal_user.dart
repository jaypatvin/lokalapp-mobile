import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/json_converters/date_time_converter.dart';
import '../services/json_converters/user_status_converter.dart';
import 'address.dart';
import 'notification_settings.dart';

part 'lokal_user.freezed.dart';
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

@freezed
class UserRegistrationStatus with _$UserRegistrationStatus {
  const factory UserRegistrationStatus({
    required String idPhoto,
    required String idType,
    required String notes,
    required int step,
    required bool verified,
  }) = _UserRegistrationStatus;

  factory UserRegistrationStatus.fromJson(Map<String, dynamic> json) =>
      _$UserRegistrationStatusFromJson(json);
}

@freezed
class UserRoles with _$UserRoles {
  const factory UserRoles({
    required bool member,
    required bool admin,
    bool? editor,
  }) = _UserRoles;

  factory UserRoles.fromJson(Map<String, dynamic> json) =>
      _$UserRolesFromJson(json);
}

@freezed
class LokalUser with _$LokalUser {
  const factory LokalUser({
    required String id,
    required Address address,
    required bool archived,
    required String birthdate,
    required String communityId,
    @DateTimeConverter() required DateTime createdAt,
    required String displayName,
    required String email,
    required String firstName,
    required String lastName,
    required UserRegistrationStatus registration,
    required UserRoles roles,
    @UserStatusConverter() required UserStatus status,
    required List<String> userUids,
    @Default(NotificationSettings()) NotificationSettings notificationSettings,
    // ignore: invalid_annotation_target
    @JsonKey(readValue: _showReadReceiptsFromMap)
    @Default(false)
        bool showReadReceipts,
    String? profilePhoto,
  }) = _LokalUser;

  factory LokalUser.fromJson(Map<String, dynamic> json) =>
      _$LokalUserFromJson(json);

  factory LokalUser.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return LokalUser.fromJson({'id': doc.id, ...doc.data()!});
  }
}

bool? _showReadReceiptsFromMap(Map<dynamic, dynamic> map, String key) {
  return map['chat_settings']?[key] ?? false;
}
