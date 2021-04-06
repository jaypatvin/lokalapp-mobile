import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthToken extends ChangeNotifier {
  String _idToken;
  bool _isLoading;

  String get token => _idToken;
  bool get isLoading => _isLoading;

  Future<void> update(User user) async {
    await _getUserToken(user);
    FirebaseAuth.instance.idTokenChanges().listen(_getUserToken);
  }

  Future<void> _getUserToken(User user) async {
    _isLoading = true;
    var token = await user.getIdToken();
    this._idToken = token;
    _isLoading = false;

    notifyListeners();
  }
}
