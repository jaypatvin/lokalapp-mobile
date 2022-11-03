import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_navigator.dart';
import '../../providers/auth.dart';
import '../../providers/community.dart';
import '../../providers/post_requests/auth_body.dart';
import '../../routers/app_router.dart';
import '../../screens/auth/profile_registration.dart';
import '../../screens/auth/register_screen.dart';
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
      final lokalInvite = await _apiService.check(_inviteCode);
      final communityId = lokalInvite.communityId;
      if (communityId.isEmpty) throw 'No Community ID returned.';

      context.read<AuthBody>()
        ..update(communityId: communityId)
        ..setInviteCode(_inviteCode);
      context
          .read<CommunityProvider>()
          .setCommunityId(lokalInvite.communityId);

      if (_displayError) {
        _displayError = false;
        notifyListeners();
      }

      final fireUser = auth.firebaseUser;
      if (fireUser != null) {
        AppRouter.rootNavigatorKey.currentState?.pushReplacement(
          AppNavigator.appPageRoute(
            builder: (_) => const ProfileRegistration(),
          ),
        );
      } else {
        AppRouter.rootNavigatorKey.currentState?.pushReplacement(
          AppNavigator.appPageRoute(
            builder: (_) => const RegisterScreen(),
          ),
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
