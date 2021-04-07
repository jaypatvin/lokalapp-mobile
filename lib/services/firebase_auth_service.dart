import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseUser {
  final String uid;
  final String idToken;
  final String email;
  const FirebaseUser({
    @required this.uid,
    @required this.idToken,
    @required this.email,
  });
}

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static FirebaseAuthService _service;
  static FirebaseAuthService get instance {
    if (_service == null) {
      _service = FirebaseAuthService();
    }
    return _service;
  }

  Future<FirebaseUser> _userFromFirebase(User user) async {
    if (user != null) {
      String idToken = await user.getIdToken();
      return FirebaseUser(
        uid: user.uid,
        idToken: idToken,
        email: user.email,
      );
    }
    return null;
  }

  Future<FirebaseUser> signUp(
      {@required String email, @required String password}) async {
    UserCredential _authResult = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return await _userFromFirebase(_authResult.user);
  }

  Future<FirebaseUser> signInWithEmail(
      {@required String email, @required String password}) async {
    final UserCredential _authResult = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    return await _userFromFirebase(_authResult.user);
  }

  Future<FirebaseUser> signInWithGoogle() async {
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
    final UserCredential _authResult =
        await _auth.signInWithCredential(credential);
    return await _userFromFirebase(_authResult.user);
  }

  Future<FirebaseUser> signInWithFacebook() async {
    final AccessToken accessToken = await FacebookAuth.instance.login();
    final OAuthCredential credential =
        FacebookAuthProvider.credential(accessToken.token);
    final UserCredential _authResult =
        await _auth.signInWithCredential(credential);

    return await _userFromFirebase(_authResult.user);
  }

  Future<FirebaseUser> startUp() async {
    final User _firebaseUser = _auth.currentUser;
    return await _userFromFirebase(_firebaseUser);
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
