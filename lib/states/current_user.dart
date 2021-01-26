import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lokalapp/models/user.dart';
import 'package:lokalapp/services/database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:lokalapp/services/get_stream_api_service.dart';

// used for auth validation in screens
enum authStatus { Success, UserNotFound, PasswordNotValid, Error }

final GoogleSignIn googleSignIn = GoogleSignIn();

class CurrentUser extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Users _currentUser = Users();
  Map<String, String> _getStreamAccount;
  String _inviteCode;

  String get uid => _auth.currentUser.uid;
  Users get getCurrentUser => _currentUser;
  Map<String, String> get getStreamAccount => _getStreamAccount;
  String get getUserInviteCode => _inviteCode;

  set setInviteCode(String inviteCode) {
    _inviteCode = inviteCode;
    notifyListeners();
  }

  Future<String> onStartUp() async {
    String retVal = "error";
    try {
      User _firebaseUser = _auth.currentUser;
      _currentUser.userUids = [];
      var _user = await Database().getUserInfo(_firebaseUser.uid);

      if (_user != null) {
        _currentUser = _user;
        await _getStreamLogin();
        print(_currentUser);
        retVal = "success";
      }
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future _getStreamLogin() async {
    var creds = await GetStreamApiService().login(_currentUser.userUids.first);
    this._getStreamAccount = {
      'user': _currentUser.userUids.first,
      'authToken': creds['authToken'],
      'feedToken': creds['feedToken'],
    };
  }

  Future<String> onSignOut() async {
    String retVal = "error";
    try {
      await _auth.signOut();
      _currentUser = Users();
      retVal = "success";
    } catch (e) {
      print(e);
    }

    notifyListeners();
    return retVal;
  }

  Future updateUser() async {
    try {
      User _firebaseUser = _auth.currentUser;
      _currentUser = await Database().getUserInfo(_firebaseUser.uid);
      await _getStreamLogin();
    } catch (e) {
      print(e);
    }
  }

  Future<authStatus> signUpUser(String email, String password) async {
    authStatus retVal = authStatus.Error;
    try {
      UserCredential _authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (_authResult != null) {
        retVal = authStatus.UserNotFound;
        _currentUser.email = _authResult.user.email;
        _currentUser.userUids.add(_authResult.user.uid);
      }
    } catch (e) {
      debugPrint(e.code);
      if (e.code == "email-already-in-use") {
        retVal = await loginUserWithEmail(email, password);
      }
    }
    return retVal;
  }

  Future<authStatus> loginUserWithEmail(String email, String password) async {
    authStatus retVal = authStatus.Error;

    try {
      UserCredential _authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      var _user = await Database().getUserInfo(_authResult.user.uid);
      //_currentUser = await Database().getUserInfo(_authResult.user.uid);

      if (_user != null) {
        _currentUser = _user;
        retVal = authStatus.Success;
        await _getStreamLogin();
      } else {
        retVal = authStatus.UserNotFound;
        _currentUser.email = _authResult.user.email;
        _currentUser.userUids.add(_authResult.user.uid);
      }
    } catch (e) {
      switch (e.code) {
        case "invalid-email":
          retVal = authStatus.UserNotFound;
          break;
        case "wrong-password":
          retVal = authStatus.PasswordNotValid;
          break;
        case "user-not-found":
          retVal = authStatus.UserNotFound;
          break;
        default:
          retVal = authStatus.Error;
      }
    }
    return retVal;
  }

  Future<authStatus> loginUserWithGoogle() async {
    authStatus retVal = authStatus.Error;
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    try {
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);

      retVal = await _signInWithCredential(credential);
    } catch (e) {
      debugPrint(e);
    }
    return retVal;
  }

  Future<authStatus> loginUserWithFacebook() async {
    authStatus retVal = authStatus.Error;
    try {
      final AccessToken accessToken = await FacebookAuth.instance.login();
      final OAuthCredential credential =
          FacebookAuthProvider.credential(accessToken.token);
      retVal = await _signInWithCredential(credential);
    } catch (e) {
      debugPrint(e);
    }
    return retVal;
  }

  Future<String> linkWithFacebook() async {
    String retVal = "error";
    UserCredential _authResult;
    try {
      final AccessToken accessToken = await FacebookAuth.instance.login();

      final OAuthCredential credential =
          FacebookAuthProvider.credential(accessToken.token);
      _authResult = await _auth.signInWithCredential(credential);
      String firstUid = _currentUser.userUids.first;
      String docIdForFb =
          await Database().getCurrentUserDocId(_authResult.user.uid);

      if (docIdForFb.isEmpty) {
        //_currentUser.userUids.add(_authResult.user.uid);
        String docId = await Database().getCurrentUserDocId(firstUid);
        retVal = await Database().updateUser(docId, _currentUser);
      }
    } catch (e) {
      retVal = e.toString();
    }
    return retVal;
  }

  Future<authStatus> _signInWithCredential(AuthCredential credential) async {
    authStatus retVal = authStatus.Error;
    try {
      UserCredential _authResult = await _auth.signInWithCredential(credential);
      var _user = await Database().getUserInfo(_authResult.user.uid);

      if (_user != null) {
        _currentUser = _user;
        retVal = authStatus.Success;
        await _getStreamLogin();
      } else {
        _currentUser.email = _authResult.user.email;
        _currentUser.userUids.add(_authResult.user.uid);
        retVal = authStatus.UserNotFound;
      }
    } catch (e) {
      debugPrint(e);
    }
    return retVal;
  }
}
