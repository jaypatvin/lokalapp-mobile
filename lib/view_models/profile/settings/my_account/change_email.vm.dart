import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChangeEmailViewModel extends ChangeNotifier {
  ChangeEmailViewModel();

  // final Auth _userAuth;
  final StreamController<String> _errorStream = StreamController.broadcast();

  bool _displayEmailError = false;
  bool _displaySignInError = false;
  String _email = '';
  String _newEmail = '';
  String _password = '';

  bool get displayEmailError => _displayEmailError;
  bool get displaySignInError => _displaySignInError;
  Stream<String> get errorStream => _errorStream.stream;

  @override
  void dispose() {
    _errorStream.close();
    super.dispose();
  }

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
    notifyListeners();
  }

  Future<void> onFormSubmit() async {
    if (_email != _newEmail) {
      _displayEmailError = true;
      notifyListeners();
      return;
    }
    try {
      // TODO: implement change Email
      throw UnimplementedError('No API to change the email in user documents.');

      // await _userAuth.changeEmail(
      //   _email,
      //   _password,
      //   _newEmail,
      // );
    } catch (e) {
      _errorStream.add(e.toString());
    }

    notifyListeners();
  }
}
