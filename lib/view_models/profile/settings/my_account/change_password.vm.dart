import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../../models/failure_exception.dart';
import '../../../../providers/auth.dart';
import '../../../../state/view_model.dart';

class ChangePasswordViewModel extends ViewModel {
  String _oldPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';

  // bool _displayPasswordMismatch = false;
  // bool get displayPasswordMismatch => _displayPasswordMismatch;

  // bool _displaySignInError = false;
  // bool get displaySignInError => _displaySignInError;

  String? _signInError;
  String? get signInError => _signInError;

  String? _passwordMismatchError;
  String? get passwordMismatchError => _passwordMismatchError;

  void onOldPasswordChanged(String value) {
    _oldPassword = value;
    // if (_displaySignInError) {
    //   _displaySignInError = false;
    // }
    if (_signInError != null) {
      _signInError = null;
    }

    notifyListeners();
  }

  void onNewPasswordChanged(String value) {
    _newPassword = value;
    // if (_displayPasswordMismatch) {
    //   _displayPasswordMismatch = false;
    // }
    if (_passwordMismatchError != null) {
      _passwordMismatchError = null;
    }
    notifyListeners();
  }

  void onConfirmPasswordChanged(String value) {
    _confirmPassword = value;
    // if (_displayPasswordMismatch) {
    //   _displayPasswordMismatch = false;
    // }
    if (_passwordMismatchError != null) {
      _passwordMismatchError = null;
    }
    notifyListeners();
  }

  String? passwordValidator(String? input) {
    String? error;

    const String numCharacterError = 'Must have at least 8 characters.';
    const String numberError = 'Must have at least one number.';
    const String specialError = 'Must have at least one special character.';

    if (input == null || input.isEmpty) {
      return '$numCharacterError\n$numberError\n$specialError';
    }

    if (input.length < 8) {
      error ??= '';
      error += '$numCharacterError\n';
    }

    if (!input.contains(RegExp('[0-9]'))) {
      error ??= '';
      error += '$numberError\n';
    }

    const pattern = r"[ `!@#$%^&*()_+\-=\[\]{};'" + r':"\\|,.<>\/?~]';
    if (!input.contains(RegExp(pattern))) {
      error ??= '';
      error += '$specialError\n';
    }

    return error?.trim();
  }

  Future<bool> onFormSubmit() async {
    if (_newPassword != _confirmPassword) {
      // _displayPasswordMismatch = true;
      _passwordMismatchError = 'Passwords do not match. Please try again.';
      notifyListeners();
      return false;
    }
    try {
      await context.read<Auth>().changePassword(
            _oldPassword,
            _newPassword,
          );
      return true;
    } on FirebaseAuthException catch (e, stack) {
      if (e.code == 'wrong-password') {
        _signInError = 'Password is incorrect. Please try again';
        notifyListeners();
      } else {
        FirebaseCrashlytics.instance.recordError(e, stack);
      }
      showToast(e.toString());
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }

    notifyListeners();
    return false;
  }

  void onFormChanged() => notifyListeners();
}
