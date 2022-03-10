import 'package:flutter/foundation.dart';

import '../../models/post_requests/user/user_create.request.dart';

class AuthBody extends ChangeNotifier {
  UserCreateRequest _authBody = const UserCreateRequest(
    firstName: '',
    lastName: '',
    street: '',
    communityId: '',
    email: '',
    displayName: '',
  );
  UserCreateRequest get request => _authBody;

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
