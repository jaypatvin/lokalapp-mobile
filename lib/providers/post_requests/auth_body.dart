import 'package:flutter/foundation.dart';

class AuthBody extends ChangeNotifier {
  final Map<String, dynamic> _authBody = <String, dynamic>{};

  Map<String, dynamic> get data => _authBody;

  String? get firstName => _authBody['first_name'];
  String? get lastName => _authBody['last_name'];
  String? get profilePhoto => _authBody['profile_photo'];
  String? get email => _authBody['email'];
  String? get street => _authBody['street'];

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
    _authBody['first_name'] = firstName ?? _authBody['first_name'];
    _authBody['last_name'] = lastName ?? _authBody['last_name'];
    _authBody['user_uid'] = userUid ?? _authBody['user_uid'];
    _authBody['street'] = address ?? _authBody['street'];
    _authBody['community_id'] = communityId ?? _authBody['community_id'];
    _authBody['profile_photo'] = profilePhoto ?? _authBody['profile_photo'];
    _authBody['email'] = email ?? _authBody['email'];
    _authBody['display_name'] = displayName ?? _authBody['display_name'];

    if (notify) notifyListeners();
  }

  void setInviteCode(String inviteCode) {
    _inviteCode = inviteCode;
    notifyListeners();
  }
}
