import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../../../providers/auth.dart';

class MyAccountViewModel {
  MyAccountViewModel(this._userAuth);

  final Auth _userAuth;

  final StreamController<String> _errorStream = StreamController.broadcast();

  Stream<String> get errorStream => _errorStream.stream;

  void dispose() {
    _errorStream.close();
  }

  bool ifEmailAuth() {
    try {
      return _userAuth.checkSignInMethod();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      _errorStream.add('Cannot change Email Address/Password: $e');
      return false;
    }
  }
}
