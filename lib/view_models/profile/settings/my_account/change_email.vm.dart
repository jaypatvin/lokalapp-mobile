import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        _displaySignInError = true;
        notifyListeners();
      } else {
        showToast(e.toString());
      }

      return false;
    } catch (e) {
      showToast(e.toString());
      return false;
    }
  }
}
