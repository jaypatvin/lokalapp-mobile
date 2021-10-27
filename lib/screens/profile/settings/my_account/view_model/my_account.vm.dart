import 'dart:async';

import '../../../../../providers/auth.dart';

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
    } catch (e) {
      _errorStream.add('Cannot change Email Address/Password: $e');
      return false;
    }
  }
}
