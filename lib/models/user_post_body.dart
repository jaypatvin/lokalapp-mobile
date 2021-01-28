import 'dart:convert';

class UserPostBody {
  String firstName;
  String lastName;
  String userUid;
  String address;
  String communityId;
  String profilePhoto;

  UserPostBody({
    this.firstName,
    this.lastName,
    this.userUid,
    this.address,
    this.communityId,
    this.profilePhoto,
  });

  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'user_uid': userUid,
      'address': address,
      'community_id': communityId,
      'profile_photo': profilePhoto,
    };
  }

  factory UserPostBody.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserPostBody(
      firstName: map['first_name'],
      lastName: map['last_name'],
      userUid: map['user_uid'],
      address: map['address'],
      communityId: map['community_id'],
      profilePhoto: map['profile_photo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserPostBody.fromJson(String source) =>
      UserPostBody.fromMap(json.decode(source));
}
