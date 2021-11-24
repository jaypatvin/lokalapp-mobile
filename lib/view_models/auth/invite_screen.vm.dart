import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/models/community.dart';
import 'package:lokalapp/providers/community.dart';
import 'package:oktoast/oktoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../providers/post_requests/auth_body.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/profile_registration.dart';
import '../../services/api/api.dart';
import '../../services/api/invite_api_service.dart';
import '../../state/view_model.dart';

class InviteScreenViewModel extends ViewModel {
  late final InviteAPIService _apiService;

  String _inviteCode = '';
  String get inviteCode => _inviteCode;

  bool _displayError = false;
  bool get displayError => _displayError;

  @override
  void init() {
    super.init();
    _apiService = InviteAPIService(context.read<API>());
  }

  void onInviteCodeChanged(String value) {
    _inviteCode = value;
    notifyListeners();
  }

  Future<void> validateInviteCode() async {
    final auth = context.read<Auth>();

    try {
      final _lokalInvite = await _apiService.check(_inviteCode);
      final communityId = _lokalInvite.communityId;
      if (communityId.isEmpty) throw 'No Community ID returned.';

      final fireUser = auth.firebaseUser;
      context.read<AuthBody>()
        ..update(communityId: communityId)
        ..setInviteCode(_inviteCode);
      context
          .read<CommunityProvider>()
          .setCommunityId(_lokalInvite.communityId);

      if (_displayError) {
        _displayError = false;
        notifyListeners();
      }
      if (fireUser != null) {
        pushNewScreen(context, screen: ProfileRegistration());
      } else {
        pushNewScreen(context, screen: RegisterScreen());
      }
    } catch (e) {
      _displayError = true;
      notifyListeners();
      showToast(e.toString());
    }
  }

  Future<void> showInviteCodeDescription(Widget dialog) async {
    return await showDialog<void>(
      context: context,
      builder: (ctx) {
        return dialog;
      },
    );
  }
}
