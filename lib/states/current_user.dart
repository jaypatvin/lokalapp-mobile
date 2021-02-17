import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_shop_post.dart';
import '../models/lokal_user.dart';
import '../services/database.dart';
import '../services/get_stream_api_service.dart';
import '../services/lokal_api_service.dart';
import 'package:http/http.dart' as http;

enum authStatus { Success, UserNotFound, PasswordNotValid, Error }

class CurrentUser extends ChangeNotifier {
  final Database _db = Database();
  final LokalApiService _lokalService = LokalApiService();
  final GetStreamApiService _getStreamApi = GetStreamApiService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LokalUser _user;
  Map<String, String> _postBody = Map();
  UserShopPost postShop = UserShopPost();
  Map<String, String> _getStreamAccount = Map();
  String _inviteCode;

  Map get getStreamAccount => _getStreamAccount;
  bool get isAuthenticated =>
      _postBody["user_uid"] != null && _postBody["user_uid"].isNotEmpty;

  List<String> get userUids => _user.userUids;
  String get id => _user.id;
  String get firstName => _user.firstName;
  String get lastName => _user.lastName;
  String get profilePhoto => _user.profilePhoto;
  String get email => _user.email;
  String get displayName => _user.displayName;
  String get communityId => _user.communityId;
  String get birthDate => _user.birthDate;
  String get status => _user.status;
  UserAddress get address => _user.address;
  UserRegistrationStatus get registrationStatus => _user.registration;
  UserRoles get roles => _user.roles;
  Timestamp get createdAt => _user.createdAt;

  Future<bool> createUser() async {
    http.Response response = await _lokalService.createUser(_postBody);
    if (response.statusCode != 200) {
      return false;
    }

    Map data = json.decode(response.body);

    if (data["status"] == "ok") {
      _user = LokalUser.fromMap(data["data"]);
      await _getStreamLogin();
      return true;
    }

    return false;
  }

  Future<bool> createShop() async {
    postShop.communityId = _user.communityId;
    var _postData = postShop.toMap();
    String jsonDecode = await _lokalService.createStore(_postData);
    Map data = json.decode(jsonDecode);

    if (data["status"] == "ok") {
      _user = LokalUser.fromMap(data["data"]);
      return true;
    }

    return false;
  }

  Future _getStreamLogin() async {
    var creds = await _getStreamApi.login(_user.userUids.first);
    this._getStreamAccount = {
      'user': _user.userUids.first,
      'authToken': creds['authToken'],
      'feedToken': creds['feedToken'],
    };
  }

  Future<List<dynamic>> getTimeline() async {
    return await _getStreamApi.getTimeline(_getStreamAccount);
  }

  Future<bool> postMessage(String message) async {
    return await _getStreamApi.postMessage(getStreamAccount, message);
  }

  Future<bool> checkInviteCode(String inviteCode) async {
    http.Response response = await _lokalService.checkInviteCode(inviteCode);
    if (response.statusCode != 200) {
      return false;
    }
    Map data = json.decode(response.body);
    if (data["status"] == "ok") {
      _postBody["community_id"] = data["data"]["community_id"];
      _inviteCode = inviteCode;
      return true;
    }
    return false;
  }

  Future<bool> claimInviteCode() async {
    String userDocId = await _db.getUserDocId(_postBody["user_uid"]);
    http.Response response =
        await _lokalService.claimInviteCode(userDocId, _inviteCode);

    if (response.statusCode != 200) {
      return false;
    }
    Map data = json.decode(response.body);
    return data["status"] == "ok";
  }

  void updatePostBody(
      {String firstName,
      String lastName,
      String userUid,
      String address,
      String communityId,
      String profilePhoto}) {
    _postBody["first_name"] = firstName ?? _postBody["first_name"];
    _postBody["last_name"] = lastName ?? _postBody["last_name"];
    _postBody["user_uid"] = userUid ?? _postBody["user_uid"];
    _postBody["street"] = address ?? _postBody["street"];
    _postBody["community_id"] = communityId ?? _postBody["community_id"];
    _postBody["profile_photo"] = profilePhoto ?? _postBody["profile_photo"];
  }

  void updateUserRegistrationInfo({
    int step,
    String idPhoto,
    bool verified,
    String notes,
    String idType,
  }) {
    var registrationStatus = _user.registration;
    _user.registration = UserRegistrationStatus(
      step: step ?? registrationStatus.step,
      idPhoto: idPhoto ?? registrationStatus.idPhoto,
      verified: verified ?? registrationStatus.verified,
      notes: notes ?? registrationStatus.notes,
      idType: idType ?? registrationStatus.idType,
    );
  }

  Future<bool> verifyUser() async {
    String status =
        await _db.updateUser(_user, "registration", _user.registration.toMap());
    return status == "success";
  }

  Future<String> onStartUp() async {
    String retVal = "error";
    try {
      User _firebaseUser = _auth.currentUser;

      Map map = await _db.getUserInfo(_firebaseUser.uid);

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
        _postBody["user_uid"] = _authResult.user.uid;
        _postBody["email"] = email;
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

      var map = await _db.getUserInfo(_authResult.user.uid);

      if (map != null) {
        this._user = LokalUser.fromMap(map);
        retVal = authStatus.Success;
        await _getStreamLogin();
      } else {
        retVal = authStatus.UserNotFound;
        _postBody["user_uid"] = _authResult.user.uid;
        _postBody["email"] = email;
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
      var map = await _db.getUserInfo(_authResult.user.uid);

      if (map != null) {
        _user = LokalUser.fromMap(map);
        retVal = authStatus.Success;
        await _getStreamLogin();
      } else {
        _postBody["user_uid"] = _authResult.user.uid;
        _postBody["email"] = _authResult.user.email;
        retVal = authStatus.UserNotFound;
      }
    } catch (e) {
      debugPrint(e);
    }
    return retVal;
  }
}
