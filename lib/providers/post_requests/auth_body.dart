import 'package:flutter/foundation.dart';

class _AuthBodyRequest {
  const _AuthBodyRequest({
    this.firstName,
    this.lastName,
    this.street,
    this.communityId,
    this.profilePhoto,
    this.email,
    this.displayName,
  });

  final String? firstName;
  final String? lastName;
  final String? street;
  final String? communityId;
  final String? profilePhoto;
  final String? email;
  final String? displayName;

  _AuthBodyRequest copyWith({
    String? firstName,
    String? lastName,
    String? street,
    String? communityId,
    String? profilePhoto,
    String? email,
    String? displayName,
  }) {
    return _AuthBodyRequest(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      street: street ?? this.street,
      communityId: communityId ?? this.communityId,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'street': street,
      'community_id': communityId,
      'profile_photo': profilePhoto,
      'email': email,
      'display_name': displayName,
    }..removeWhere((key, value) {
        if (key.isEmpty || value == null) return true;
        if (value is String) {
          return value.isEmpty;
        }

        return false;
      });
  }

  @override
  String toString() {
    return '_AuthBodyRequest(firstName: $firstName, lastName: $lastName, '
        'street: $street, communityId: $communityId, '
        'profilePhoto: $profilePhoto, email: $email, '
        'displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _AuthBodyRequest &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.street == street &&
        other.communityId == communityId &&
        other.profilePhoto == profilePhoto &&
        other.email == email &&
        other.displayName == displayName;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        street.hashCode ^
        communityId.hashCode ^
        profilePhoto.hashCode ^
        email.hashCode ^
        displayName.hashCode;
  }
}

class AuthBody extends ChangeNotifier {
  _AuthBodyRequest _authBody = const _AuthBodyRequest();
  Map<String, dynamic> get data => _authBody.toMap();

  String? get firstName => _authBody.firstName;
  String? get lastName => _authBody.lastName;
  String? get profilePhoto => _authBody.profilePhoto;
  String? get email => _authBody.email;
  String? get street => _authBody.street;

  String? _inviteCode;
  String? get inviteCode => _inviteCode;

  void update({
    String? firstName,
    String? lastName,
    String? userUid,
    String? address,
    String? communityId,
    String? profilePhoto,
    String? email,
    String? displayName,
    bool notify = true,
  }) {
    _authBody = _authBody.copyWith(
      firstName: firstName,
      lastName: lastName,
      street: address,
      communityId: communityId,
      profilePhoto: profilePhoto,
      email: email,
      displayName: displayName,
    );

    if (notify) notifyListeners();
  }

  void setInviteCode(String inviteCode) {
    _inviteCode = inviteCode;
    notifyListeners();
  }
}
