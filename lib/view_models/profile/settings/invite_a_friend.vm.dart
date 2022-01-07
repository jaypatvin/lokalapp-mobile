import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:validators/validators.dart';

import '../../../models/failure_exception.dart';
import '../../../models/lokal_invite.dart';
import '../../../screens/profile/settings/invite_a_friend/invite_sent.dart';
import '../../../services/api/api.dart';
import '../../../services/api/invite_api_service.dart';
import '../../../state/view_model.dart';

class InviteAFriendViewModel extends ViewModel {
  InviteAFriendViewModel(this._api);

  late String _emailAddress;
  String get emailAddress => _emailAddress;

  String? _emailErrorText;
  String? get emailErrorText => _emailErrorText;

  late String _phoneNumber;
  String get phoneNumber => _phoneNumber;

  late final InviteAPIService _inviteApiService;
  final API _api;

  @override
  void init() {
    _emailAddress = '';
    _phoneNumber = '';

    _inviteApiService = InviteAPIService(_api);
  }

  void onEmailChanged(String value) {
    if (_emailErrorText != null) _emailErrorText = null;
    _emailAddress = value;
    notifyListeners();
  }

  void onPhoneNumberChange(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  Future<void> sendInviteCode() async {
    try {
      if (_emailAddress.isEmpty && _phoneNumber.isEmpty) {
        throw FailureException('Email Address should not be empty!');
      }

      if (!isEmail(_emailAddress)) {
        _emailErrorText = 'Enter a valid email.';
        debugPrint(_emailErrorText);
        notifyListeners();
        return;
      }

      late final LokalInvite invite;
      // We give priority to the email address
      if (_emailAddress.isNotEmpty) {
        invite = await _inviteApiService.inviteAFriend(
          {
            'email': _emailAddress,
          },
        );
      } else if (_phoneNumber.isNotEmpty) {
        throw UnimplementedError('Phone number is not yet supported');
      }
      if (invite.code == null) throw 'No Invite code Provided';

      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (_) => InviteSent(invite)),
      );
    } catch (e) {
      showToast(e.toString());
    }
  }
}
