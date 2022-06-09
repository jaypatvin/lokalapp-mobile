import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../../models/app_navigator.dart';
import '../../../../providers/auth.dart';
import '../../../../routers/app_router.dart';
import '../../../../state/view_model.dart';
import '../../../../widgets/reset_password_received.dart';

class ResetPasswordViewModel extends ViewModel {
  String _emailAddress = '';

  void onEmailAddressChanged(String value) {
    _emailAddress = value;
    notifyListeners();
  }

  Future<void> onSubmit() async {
    try {
      await context.read<Auth>().resetPassword(email: _emailAddress);
      AppRouter.profileNavigatorKey.currentState?.pushReplacement(
        AppNavigator.appPageRoute(
          builder: (_) => const ResetPasswordReceived(),
        ),
      );
    } catch (e, stack) {
      if (e is FirebaseAuthException) {
        if (e.code == 'auth/invalid-email') {
          showToast('You have entered an invalid email.');
        } else if (e.code == 'auth/user-not-found') {
          showToast('The user cannot be found!');
        }
      } else {
        FirebaseCrashlytics.instance.recordError(e, stack);
      }
    }
  }
}
