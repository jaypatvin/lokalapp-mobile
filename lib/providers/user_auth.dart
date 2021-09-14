import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthStatus {
  Success,
  NewUser,
  UserNotFound,
  InvalidEmail,
  InvalidPassword,
  Error,
}

class UserAuth extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;
  User get user => _user;

  void _onUserChanges() {
    _auth.userChanges().listen((user) {
      if (user != null) {
        _user = user;
        notifyListeners();
      }
    });
  }

  Future<AuthStatus> signUp(String email, String password) async {
    AuthStatus retVal = AuthStatus.Error;
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (authResult != null) {
        retVal = AuthStatus.NewUser;
        this._user = authResult.user;
        notifyListeners();
      }
    } catch (e) {
      if (e.code == "email-already-in-use") {
        retVal = await loginWithEmail(email, password);
      }
    }
    return retVal;
  }

  Future<AuthStatus> loginWithEmail(String email, String password) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (authResult != null) {
        this._user = authResult.user;
        notifyListeners();
      }
      return AuthStatus.Success;
    } catch (e) {
      switch (e.code) {
        case "invalid-email":
          return AuthStatus.InvalidEmail;
        case "wrong-password":
          return AuthStatus.InvalidPassword;
        case "user-not-found":
          return AuthStatus.UserNotFound;
        default:
          return AuthStatus.Error;
      }
    }
  }

  Future<AuthStatus> loginWithGoogle() async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );

      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      if (authResult != null) {
        this._user = authResult.user;
        notifyListeners();
      }
      return AuthStatus.Success;
    } catch (e) {
      print(e);
      return AuthStatus.Error;
    }
  }

  Future<AuthStatus> loginWithFacebook() async {
    try {
      final AccessToken accessToken = await FacebookAuth.instance.login();
      final OAuthCredential credential =
          FacebookAuthProvider.credential(accessToken.token);
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      if (authResult != null) {
        this._user = authResult.user;
        notifyListeners();
      }
      return AuthStatus.Success;
    } catch (e) {
      return AuthStatus.Error;
    }
  }

  Future<AuthStatus> logOut() async {
    try {
      await _auth.signOut();
      notifyListeners();
      return AuthStatus.Success;
    } catch (e) {
      return AuthStatus.Error;
    }
  }

  Future<AuthStatus> onStartUp() async {
    try {
      final User _firebaseUser = _auth.currentUser;
      await _firebaseUser.reload();

      if (_firebaseUser != null) {
        this._user = _firebaseUser;
        _onUserChanges();
        notifyListeners();
        return AuthStatus.Success;
      }
      return AuthStatus.Error;
    } catch (e) {
      return AuthStatus.Error;
    }
  }
}
