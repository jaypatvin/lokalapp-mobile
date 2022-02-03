import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../../models/failure_exception.dart';
import '../../../../providers/auth.dart';
import '../../../../state/view_model.dart';

class ChangeEmailViewModel extends ViewModel {
  bool _displayEmailError = false;
  bool _displaySignInError = false;

  String _email = '';
  String _newEmail = '';
  String _password = '';

  bool get displayEmailError => _displayEmailError;
  bool get displaySignInError => _displaySignInError;

  void onEmailChanged(String value) {
    _email = value;
    if (_displayEmailError) {
      _displayEmailError = false;
    }
    notifyListeners();
  }

  void onNewEmailChanged(String value) {
    _newEmail = value;
    if (_displayEmailError) {
      _displayEmailError = false;
    }
    notifyListeners();
  }

  void onPasswordChanged(String value) {
    _password = value;
    if (_displaySignInError) {
      _displaySignInError = false;
    }
    notifyListeners();
  }

  Future<bool> onFormSubmit() async {
    if (_email != _newEmail) {
      _displayEmailError = true;
      notifyListeners();
      return false;
    }
    try {
      await context.read<Auth>().changeEmail(
            password: _password,
            newEmail: _newEmail,
          );
      return true;
    } on FirebaseAuthException catch (e, stack) {
      if (e.code == 'wrong-password') {
        _displaySignInError = true;
        notifyListeners();
      } else if (e.code != 'email-already-in-use') {
        FirebaseCrashlytics.instance.recordError(e, stack);
      }
      showToast(e.toString());
      return false;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
      return false;
    }
  }
}
