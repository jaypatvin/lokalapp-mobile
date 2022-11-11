import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/lokal_user.dart';

class UserStatusConverter implements JsonConverter<UserStatus, String> {
  const UserStatusConverter();

  @override
  UserStatus fromJson(String status) {
    for (final userStatus in UserStatus.values) {
      if (status == userStatus.value) return userStatus;
    }
    return UserStatus.pending;
  }

  @override
  String toJson(UserStatus status) => status.value;
}
