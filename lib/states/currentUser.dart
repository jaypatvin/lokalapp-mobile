import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lokalapp/models/user.dart';
import 'package:flutter/services.dart';
import 'package:lokalapp/services/database.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      User _firebaseUser = await _auth.currentUser;
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

  Future<String> signUpUser(String email, String password, String firstName, String lastName, String address) async {
    String retVal = "error";
    Users _user = Users();
    try {
      UserCredential _authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user.uid = _authResult.user.uid;
      _user.email = _authResult.user.email;
      _user.firstName = firstName,
    _user.lastName = lastName,
      String _returnString = await Database().createUser(_user);
      // print(_user.uid);
      // print(_user.email);
      if (_returnString == "success") {
        retVal = "success";
      }
    } on PlatformException catch (e) {
      retVal = e.message;
    } catch (e) {
      retVal = e.message;
    }
    return retVal;
  }

  Future<String> loginUserWithEmail(String email, String password) async {
    String retVal = "error";

    try {
      UserCredential _authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _currentUser = await Database().getUserInfo(_authResult.user.uid);
      if (_currentUser != null) {
        retVal = "success";
        print(_currentUser.email);
      }
    } catch (e) {
      retVal = e.message;
    }
    return retVal;
  }



  Future<String> loginUserWithGoogle() async {
    String retVal = "error";
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    Users _users = Users();
    try {
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
      UserCredential _authResult = await _auth.signInWithCredential(credential);
      if (_authResult.additionalUserInfo.isNewUser) {
        _users.uid = _authResult.user.uid;
        _users.email = _authResult.user.email;
        Database().createUser(_users);
      }
      _currentUser = await Database().getUserInfo(_authResult.user.uid);

      if (_currentUser != null) {
        retVal = "success";
      }
    } on PlatformException catch (e) {
      retVal = e.message;
      print(e.message);
    } catch (e) {
      // retVal = e.message;
      print(e);
    }
    return retVal;
  }
}
