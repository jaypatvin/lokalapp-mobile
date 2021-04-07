import 'package:flutter/foundation.dart';

class AuthBody extends ChangeNotifier {
  Map<String, dynamic> _authBody = Map();

  Map get data => _authBody;

  void update({
    String firstName,
    String lastName,
    String userUid,
    String address,
    String communityId,
    String profilePhoto,
    String email,
  }) {
    _authBody["first_name"] = firstName ?? _authBody["first_name"];
    _authBody["last_name"] = lastName ?? _authBody["last_name"];
    _authBody["user_uid"] = userUid ?? _authBody["user_uid"];
    _authBody["street"] = address ?? _authBody["street"];
    _authBody["community_id"] = communityId ?? _authBody["community_id"];
    _authBody["profile_photo"] = profilePhoto ?? _authBody["profile_photo"];
    _authBody["email"] = email ?? _authBody["email"];

    notifyListeners();
  }
}
