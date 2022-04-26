import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/app_router.dart';
import '../../providers/auth.dart';
import '../../state/view_model.dart';

class ForgotPasswordScreenViewModel extends ViewModel {
  String _emailAddress = '';

  final _appRouter = locator<AppRouter>();

  void onEmailAddressChanged(String value) {
    _emailAddress = value;
    notifyListeners();
  }

  Future<void> onSubmit() async {
    try {
      await context.read<Auth>().resetPassword(email: _emailAddress);
      _appRouter.navigateTo(
        AppRoute.root,
        Routes.resetPasswordReceived,
        replace: true,
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
