import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/lokal_user.dart';
import '../services/database.dart';
import '../services/lokal_api_service.dart';

enum UserState { LoggedIn, LoggedOut, Loading, NotRegistered, Initial, Error }

class CurrentUser extends ChangeNotifier {
  LokalUser _user;
  String _idToken;
  UserState _state = UserState.Initial;

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

  UserState get state => _state;
  String get idToken => _idToken;

  Future<void> register(Map postBody) async {
    _state = UserState.Loading;
    try {
      http.Response response = await LokalApiService.instance.user
          .create(data: postBody, idToken: _idToken);
      if (response.statusCode != 200) {
        _state = UserState.Error;
        notifyListeners();
        return;
      }

      Map data = json.decode(response.body);

      if (data["status"] == "ok") {
        _user = LokalUser.fromMap(data["data"]);
        _state = UserState.LoggedIn;
        notifyListeners();
        return;
      }
      _state = UserState.Error;
    } catch (e) {
      _state = UserState.Error;
    }
    notifyListeners();
  }

  Future<void> fetch(User user) async {
    _state = UserState.Loading;

    if (_idToken == null || _idToken.isEmpty) {
      _idToken = await user.getIdToken();
      FirebaseAuth.instance.idTokenChanges().listen(
          (user) => user.getIdToken().then((token) => _idToken = token));
    }

    String docId = await Database.instance.getUserDocId(user.uid);
    if (docId != null && docId.isNotEmpty) {
      http.Response response = await LokalApiService.instance.user
          .getById(userId: docId, idToken: _idToken);

      if (response.statusCode == 200) {
        Map map = json.decode(response.body);
        if (map["status"] == "ok" && map['data'] != null) {
          _user = LokalUser.fromMap(map['data']);
          _state = UserState.LoggedIn;
        } else {
          _user = null;
          _state = UserState.LoggedOut;
        }
      } else {
        _user = null;
        _state = UserState.LoggedOut;
      }
    } else {
      _state = UserState.NotRegistered;
    }
    notifyListeners();
  }

  Future<bool> verify(Map body) async {
    http.Response response = await LokalApiService.instance.user.update(
      data: {"id": this.id, "registration": body},
      idToken: this.idToken,
    );

    if (response.statusCode != 200) return false;

    Map data = json.decode(response.body);
    return data["status"] == "ok";
  }

  Future<bool> update(Map body) async {
    http.Response response = await LokalApiService.instance.user.update(
      data: {"id": this.id, ...body},
      idToken: idToken,
    );

    if (response.statusCode != 200) return false;

    Map data = json.decode(response.body);

    if (data["status"] != "ok") return false;

    try {
      // update user data after updating
      // should not throw any errors except on network error connection
      response = await LokalApiService.instance.user
          .getById(userId: _user.id, idToken: _idToken);
      data = json.decode(response.body);
      _user = LokalUser.fromMap(data['data']);
      notifyListeners();
      return true;
    } catch (e) {
      // TODO: retry fetching user data
      return false;
    }
  }

  void reset() {
    _user = null;
    _idToken = null;
    _state = UserState.LoggedOut;
    notifyListeners();
  }
}
