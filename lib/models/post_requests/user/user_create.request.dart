import 'package:json_annotation/json_annotation.dart';

part 'user_create.request.g.dart';

@JsonSerializable()
class UserCreateRequest {
  const UserCreateRequest({
    required this.firstName,
    required this.lastName,
    required this.street,
    required this.communityId,
    required this.email,
    required this.displayName,
    this.profilePhoto,
  });
  @JsonKey(required: true)
  final String firstName;

  @JsonKey(required: true)
  final String lastName;

  @JsonKey(required: true)
  final String street;

  @JsonKey(required: true)
  final String communityId;

  final String? profilePhoto;

  @JsonKey(required: true)
  final String email;

  @JsonKey(required: true)
  final String displayName;

  factory UserCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$UserCreateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserCreateRequestToJson(this);

  UserCreateRequest copyWith({
    String? firstName,
    String? lastName,
    String? street,
    String? communityId,
    String? profilePhoto,
    String? email,
    String? displayName,
  }) {
    return UserCreateRequest(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      street: street ?? this.street,
      communityId: communityId ?? this.communityId,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  String toString() {
    return 'UserRequest(firstName: $firstName, lastName: $lastName, '
        'street: $street, communityId: $communityId, '
        'profilePhoto: $profilePhoto, email: $email, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserCreateRequest &&
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
