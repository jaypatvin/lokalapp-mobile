import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import '../../../app/app.locator.dart';
import '../../../models/app_navigator.dart';
import '../../../models/failure_exception.dart';
import '../../../models/lokal_invite.dart';
import '../../../models/post_requests/shared/application_log.dart';
import '../../../screens/profile/settings/invite_a_friend/invite_sent.dart';
import '../../../services/api/api.dart';
import '../../../services/api/invite_api.dart';
import '../../../services/application_logger.dart';
import '../../../state/view_model.dart';

class InviteAFriendViewModel extends ViewModel {
  late String _emailAddress;
  String get emailAddress => _emailAddress;

  String? _emailErrorText;
  String? get emailErrorText => _emailErrorText;

  late String _phoneNumber;
  String get phoneNumber => _phoneNumber;

  final InviteAPI _inviteApiService = locator<InviteAPI>();

  @override
  void init() {
    _emailAddress = '';
    _phoneNumber = '';
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
        invite = await _inviteApiService.inviteAFriend(_emailAddress);
      } else if (_phoneNumber.isNotEmpty) {
        throw UnimplementedError('Phone number is not yet supported');
      }
      if (invite.code == null) throw 'No Invite code Provided';

      await context
          .read<ApplicationLogger>()
          .log(actionType: ActionTypes.userInvite);

      Navigator.of(context).pushReplacement(
        AppNavigator.appPageRoute(builder: (_) => InviteSent(invite)),
      );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }
}
