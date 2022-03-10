import 'package:json_annotation/json_annotation.dart';

import '../../lokal_user.dart';

part 'user_update.request.g.dart';

@JsonSerializable()
class UserUpdateRequest {
  const UserUpdateRequest({
    this.firstName,
    this.lastName,
    this.street,
    this.communityId,
    this.displayName,
    this.isAdmin,
    this.status,
    this.profilePhoto,
  });

  final String? firstName;
  final String? lastName;
  final String? street;
  final String? communityId;
  final String? displayName;
  final bool? isAdmin;

  @JsonKey(fromJson: _userStatusFromJson, toJson: _userStatusToJson)
  final UserStatus? status;
  final String? profilePhoto;

  factory UserUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$UserUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserUpdateRequestToJson(this);
}

UserStatus? _userStatusFromJson(String status) {
  for (final userStatus in UserStatus.values) {
    if (status == userStatus.value) return userStatus;
  }
  return null;
}

String? _userStatusToJson(UserStatus? status) => status?.value;
