import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lokalapp/models/user.dart';
import 'package:flutter/services.dart';
import 'package:lokalapp/services/database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// used for auth validation in screens
enum authStatus { Success, UserNotFound, PasswordNotValid, Error }

final GoogleSignIn googleSignIn = GoogleSignIn();

class CurrentUser extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Users _currentUser = Users();

  Users get getCurrentUser => _currentUser;
  
  String get uid => uid;
  String get email => email;
  Future<String> onStartUp() async {
    String retVal = "error";
    try {
      User _firebaseUser = _auth.currentUser;
      _currentUser = await Database().getUserInfo(_firebaseUser.uid);
      
      if (_currentUser != null) {
        print(_currentUser);
        
        retVal = "success";
      }
    } catch (e) {
      print(e);
    }
    return retVal;
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
    return retVal;
  }

  Future<String> signUpUser(String email, String password) async {
    String retVal = "error";
    Users _user = Users(userUids: <String>[]);
    try {
      UserCredential _authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user.userUids.add(_authResult.user.uid);
      _user.email = _authResult.user.email;
      //_user.firstName = firstName,
      // _user.lastName = lastName,
      String _returnString = await Database().createUser(_user);
      // print(_user.uid);
      // print(_user.email);
      if (_returnString == "success") {
        retVal = "success";
      }
    } on PlatformException catch (e) {
      retVal = e.message;
    } on NoSuchMethodError catch (e) {
      debugPrint(e.stackTrace.toString());
    } catch (e) {
      retVal = e.message;
    }
    return retVal;
  }

  Future<authStatus> loginUserWithEmail(String email, String password) async {
    authStatus retVal = authStatus.Error;

    try {
      UserCredential _authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _currentUser = await Database().getUserInfo(_authResult.user.uid);
      
      if (_currentUser != null) {
        retVal = authStatus.Success;
      }
    } catch (e) {
      switch (e.code) {
        case "invalid-email":
          retVal = authStatus.UserNotFound;
          break;
        case "wrong-password":
          retVal = authStatus.PasswordNotValid;
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
        _currentUser.userUids.add(_authResult.user.uid);
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
      _currentUser = await Database().getUserInfo(_authResult.user.uid);

      if (_currentUser != null) {
        retVal = authStatus.Success;
      } else {
        retVal = authStatus.UserNotFound;
      }
    } catch (e) {
      debugPrint(e);
    }
    return retVal;
  }
}
