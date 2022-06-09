import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../../models/failure_exception.dart';
import '../../../../providers/auth.dart';
import '../../../../state/view_model.dart';

enum AccountActions {
  changeEmail,
  changePassword,
  resetPassword,
}

class MyAccountViewModel extends ViewModel {
  late final Auth _userAuth;

  @override
  void init() {
    super.init();
    _userAuth = context.read<Auth>();
  }

  bool ifEmailAuth({AccountActions? action}) {
    try {
      return _userAuth.checkSignInMethod();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);

      if (e is FailureException) {
        final String _operation;
        if (action != null) {
          switch (action) {
            case AccountActions.changeEmail:
              _operation = 'change email';
              break;
            case AccountActions.changePassword:
              _operation = 'change password';
              break;
            case AccountActions.resetPassword:
              _operation = 'reset password';
              break;
          }
        } else {
          _operation = 'perform operation';
        }
        showToast('Cannot $_operation: ${e.details}');
      }

      return false;
    }
  }
}
