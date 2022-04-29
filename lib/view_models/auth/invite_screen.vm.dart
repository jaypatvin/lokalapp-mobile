import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/app_router.dart';
import '../../providers/auth.dart';
import '../../providers/community.dart';
import '../../providers/post_requests/auth_body.dart';
import '../../services/api/api.dart';
import '../../services/api/invite_api.dart';
import '../../state/view_model.dart';

class InviteScreenViewModel extends ViewModel {
  String _inviteCode = '';
  String get inviteCode => _inviteCode;

  bool _displayError = false;
  bool get displayError => _displayError;

  final _appRouter = locator<AppRouter>();
  final InviteAPI _apiService = locator<InviteAPI>();

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

      final fireUser = auth.firebaseUser;
      if (fireUser != null) {
        _appRouter.navigateTo(
          AppRoute.root,
          Routes.profileRegistration,
          replace: true,
        );
      } else {
        _appRouter.navigateTo(
          AppRoute.root,
          Routes.registerScreen,
          replace: true,
        );
      }
    } catch (e, stack) {
      _displayError = true;
      FirebaseCrashlytics.instance.recordError(e, stack);
      notifyListeners();
    }
  }

  Future<void> showInviteCodeDescription(Widget dialog) async {
    return showDialog<void>(
      context: context,
      builder: (ctx) {
        return dialog;
      },
    );
  }
}
