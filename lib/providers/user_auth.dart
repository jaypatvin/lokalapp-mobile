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

// TODO: checking for errors (no authResult etc.)
class UserAuth extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  User? get user => _user;

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
    } on FirebaseAuthException catch (e) {
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
    } on FirebaseAuthException catch (e) {
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

      GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleAuth =
          await _googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      if (authResult.user != null) {
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
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final AccessToken accessToken = loginResult.accessToken!;
      final OAuthCredential credential =
          FacebookAuthProvider.credential(accessToken.token);
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);

      if (authResult.user != null) {
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
      final User _firebaseUser = _auth.currentUser!;
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

  bool checkSignInMethod() {
    final userInfos = _auth.currentUser!.providerData;
    final result = userInfos.any(
      (userInfo) => userInfo.providerId == EmailAuthProvider.PROVIDER_ID,
    );

    if (!result) {
      for (final userInfo in userInfos) {
        if (userInfo.providerId == EmailAuthProvider.PROVIDER_ID) {
          debugPrint('Signed in with Email.');
        } else if (userInfo.providerId == GoogleAuthProvider.PROVIDER_ID) {
          debugPrint('Signed in with Google.');
          throw ('Signed in with Google.');
        } else if (userInfo.providerId == FacebookAuthProvider.PROVIDER_ID) {
          debugPrint('Signed in with Google.');
          throw ('Signed in with Facebook');
        }
      }
    }

    return result;
  }

  Future<void> changeEmail(
    String email,
    String password,
    String newEmail,
  ) async {
    try {
      checkSignInMethod();
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _auth.currentUser!.reauthenticateWithCredential(
        userCredential.credential!,
      );
      return await _auth.currentUser!.updateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      throw (e.code);
    } catch (e) {
      throw (e);
    }
  }

  Future<void> changePassword(
    String email,
    String password,
    String newPassword,
  ) async {
    try {
      checkSignInMethod();
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _auth.currentUser!.reauthenticateWithCredential(
        userCredential.credential!,
      );
      return await _auth.currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw (e.code);
    } catch (e) {
      throw (e);
    }
  }
}
