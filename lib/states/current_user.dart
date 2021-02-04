import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lokalapp/models/user_shop_post.dart';
import '../models/lokal_user.dart';
import '../models/user_post_body.dart';
import '../services/database.dart';
import '../services/get_stream_api_service.dart';

enum authStatus { Success, UserNotFound, PasswordNotValid, Error }
final GoogleSignIn googleSignIn = GoogleSignIn();

class CurrentUser extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  LokalUser _user;
  UserPostBody postBody = UserPostBody();
  UserShopPost postShop = UserShopPost();
  Map<String, String> getStreamAccount;
  String _inviteCode;

  LokalUser get getCurrentUser => _user;
  set setInviteCode(value) => _inviteCode = value;
  String get getUserInviteCode => _inviteCode;

  Future<bool> createUser() async {
    postBody.communityId =
        await Database().getCommunityIdFromInvite(_inviteCode);
    var _postData = postBody.toMap();
    String jsonData = await Database().createUserPostRequest(_postData);
    Map data = json.decode(jsonData);

    if (data["status"] == "ok") {
      _user = LokalUser.fromMap(data["data"]);
      await _getStreamLogin();
      return true;
    }

    return false;
  }

  Future<bool> createShop() async {
 postShop.communityId =
        await Database().getCommunityIdFromInvite(_inviteCode);
    var _postData = postShop.toMap();
    String jsonData = await Database().createStorePostRequest(_postData);
    Map data = json.decode(jsonData);

    if (data["status"] == "ok") {
      _user = LokalUser.fromMap(data["data"]);
      // await _getStreamLogin();
      return true;
    }

    return false;
  }
  Future<String> onStartUp() async {
    String retVal = "error";
    try {
      User _firebaseUser = _auth.currentUser;

      Map map = await Database().getUserInfo(_firebaseUser.uid);

      if (map != null) {
        this._user = LokalUser.fromMap(map);
        await _getStreamLogin();
        print(_user);
        retVal = "success";
      }
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future _getStreamLogin() async {
    var creds = await GetStreamApiService().login(_user.userUids.first);
    this.getStreamAccount = {
      'user': _user.userUids.first,
      'authToken': creds['authToken'],
      'feedToken': creds['feedToken'],
    };
  }

  Future<String> onSignOut() async {
    String retVal = "error";
    try {
      await _auth.signOut();
      _user = LokalUser();
      retVal = "success";
    } catch (e) {
      print(e);
    }

    notifyListeners();
    return retVal;
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
        postBody.userUid = _authResult.user.uid;
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

      var map = await Database().getUserInfo(_authResult.user.uid);

      if (map != null) {
        this._user = LokalUser.fromMap(map);
        retVal = authStatus.Success;
        await _getStreamLogin();
      } else {
        retVal = authStatus.UserNotFound;
        postBody.userUid = _authResult.user.uid;
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

  Future<authStatus> _signInWithCredential(AuthCredential credential) async {
    authStatus retVal = authStatus.Error;
    try {
      UserCredential _authResult = await _auth.signInWithCredential(credential);
      var map = await Database().getUserInfo(_authResult.user.uid);

      if (map != null) {
        _user = LokalUser.fromMap(map);
        retVal = authStatus.Success;
        await _getStreamLogin();
      } else {
        postBody.userUid = _authResult.user.uid;
        retVal = authStatus.UserNotFound;
      }
    } catch (e) {
      debugPrint(e);
    }
    return retVal;
  }
}
