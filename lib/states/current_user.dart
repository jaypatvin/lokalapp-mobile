import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/activity_feed.dart';
import '../models/lokal_user.dart';
import '../models/user_product.dart';
import '../models/user_product_post.dart';
import '../models/user_shop.dart';
import '../models/user_shop_post.dart';
import '../services/database.dart';
import '../services/firebase_auth_service.dart';
import '../services/lokal_api_service.dart';

enum FirebaseAuthStatus { Success, UserNotFound, PasswordNotValid, Error }

class CurrentUser extends ChangeNotifier {
  //TODO: REFACTOR (Single-Responsibility Principle)
  LokalUser _user;
  Map<String, String> _postBody = Map();
  Map<String, String> _postShop = Map();
  Map<String, String> _getStreamAccount = Map();
  String _inviteCode;
  String _userIdToken;
  UserShopPost postShop = UserShopPost();
  UserProductPost postProduct = UserProductPost();

  List<UserProduct> _userProducts = [];
  List<UserProduct> _communityProducts = [];
  List<ShopModel> _userShops = [];

  Map get getStreamAccount => _getStreamAccount;
  bool get isAuthenticated =>
      _postBody["user_uid"] != null && _postBody["user_uid"].isNotEmpty;

  List<UserProduct> get userProducts => UnmodifiableListView(_userProducts);
  List<UserProduct> get communityProducts =>
      UnmodifiableListView(_communityProducts);
  List<ShopModel> get userShops => UnmodifiableListView(_userShops);

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

  Future<bool> register() async {
    http.Response response = await LokalApiService.instance.user
        .create(data: _postBody, idToken: _userIdToken);
    if (response.statusCode != 200) {
      return false;
    }

    Map data = json.decode(response.body);

    if (data["status"] == "ok") {
      _user = LokalUser.fromMap(data["data"]);

      // added to remove states for add shops
      //can be removed for registration
      await getShops();

      // since we have one shop, we only need to get all products for the user
      // can be removed for registration
      await getUserProducts();

      return true;
    }

    return false;
  }

  Future<bool> update() async {
    if (_user.id == null || _user.id.isEmpty) {
      _user.id = await Database().getUserDocId(_user.userUids.first);
    }
    Map<String, dynamic> updateData = _user.toMap();
    http.Response response = await LokalApiService.instance.user
        .update(data: updateData, idToken: _userIdToken);
    if (response.statusCode != 200) {
      return false;
    }

    Map receivedData = json.decode(response.body);

    if (receivedData["status"] == "ok") {
      _user = LokalUser.fromMap(receivedData);
      return true;
    }

    return false;
  }

  /*-------------------------------shops-------------------------------*/
  Future<bool> createShop() async {
    postShop.communityId = _user.communityId;
    var _postData = postShop.toMap();
    var response = await LokalApiService.instance.shop
        .create(data: _postData, idToken: _userIdToken);

    if (response.statusCode != 200) {
      return false;
    }
    Map data = json.decode(response.body);

    if (data["status"] == "ok") {
      await getShops();
      return true;
    }

    return false;
  }

  Future<bool> getShops() async {
    http.Response response = await LokalApiService.instance.shop
        .getByUserId(userId: _user.id, idToken: _userIdToken);

    if (response.statusCode != 200) {
      return false;
    }
    Map data = json.decode(response.body);

    if (data["status"] == "ok") {
      List<ShopModel> shops = [];
      for (var shopData in data['data']) {
        var shop = ShopModel.fromMap(shopData);
        shops.add(shop);
      }
      _userShops = shops;
      return true;
    }

    return false;
  }

  Future<bool> updateShop(String uid) async {
    if (_user.id == null || _user.id.isEmpty) {
      _user.id = await Database().getUserDocId(_user.userUids.first);
    }

    postShop.communityId = _user.communityId;
    var _postData = postShop.toMap();
    http.Response response = await LokalApiService.instance.shop
        .update(data: _postData, idToken: _userIdToken, id: _userShops[0].id);
    ;

    if (response.statusCode != 200) {
      return false;
    }

    Map data = json.decode(response.body);

    if (data["status"] == "ok") {
      await getShops();
      return true;
    } else {
      print(data["status"]);
    }

    return false;
  }

  /* ---------------------------------------------------------------------- */

  /*-------------------------------products-------------------------------*/

  //TODO: handle errors
  Future<bool> createProduct() async {
    postProduct.shopId = _userShops[0].id;
    var _postData = postProduct.toMap();
    var response = await LokalApiService.instance.product
        .create(data: _postData, idToken: _userIdToken);

    if (response.statusCode != 200) {
      return false;
    }
    Map data = json.decode(response.body);

    if (data["status"] == "ok") {
      await getUserProducts();
      return true;
    }

    return false;
  }

  Future<bool> getUserProducts() async {
    var response = await LokalApiService.instance.product
        .getUserProducts(idToken: _userIdToken, userId: _user.id);

    if (response.statusCode != 200) {
      return false;
    }
    Map data = json.decode(response.body);

    if (data['status'] == "ok") {
      List<UserProduct> products = [];
      for (var product in data['data']) {
        var _product = UserProduct.fromMap(product);
        products.add(_product);
      }
      _userProducts = products;
      return true;
    }

    return false;
  }

  Future<List<UserProduct>> getCommunityProducts() async {
    var response = await LokalApiService.instance.product.getCommunityProducts(
        idToken: _userIdToken, communityId: _user.communityId);

    if (response.statusCode != 200) {
      return [];
    }
    Map data = json.decode(response.body);

    if (data['status'] == "ok") {
      List<UserProduct> products = [];
      for (var product in data['data']) {
        var _product = UserProduct.fromMap(product);
        products.add(_product);
      }
      _communityProducts = products;
    }

    return communityProducts;
  }

  Future<List<ActivityFeed>> getCommunityFeed() async {
    var response = await LokalApiService.instance.activity
        .getCommunityActivities(
            communityId: communityId, idToken: _userIdToken);

    if (response.statusCode != 200) {
      return [];
    }

    Map data = json.decode(response.body);

    if (data['status'] == 'ok') {
      List<ActivityFeed> feed = [];
      for (var activity in data['data']) {
        var activityFeed = ActivityFeed.fromMap(activity);

        feed.add(activityFeed);
      }
      return feed..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      return [];
    }
  }

  Future<bool> postActivityFeed(String message) async {
    //TODO: implement posting of activityFeed
    var response = await LokalApiService.instance.activity.create(
      idToken: _userIdToken,
      data: {
        'community_id': communityId,
        'user_id': id,
        'message': message,
      },
    );

    if (response.statusCode != 200) {
      return false;
    }
    var data = json.decode(response.body);
    if (data['status'] == 'ok') {
      return true;
    }

    return false;
  }

  Future<bool> checkInviteCode(String inviteCode) async {
    http.Response response = await LokalApiService.instance.invite
        .check(code: inviteCode, idToken: _userIdToken);
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
    String userDocId = await Database().getUserDocId(_postBody["user_uid"]);
    http.Response response = await LokalApiService.instance.invite.claim(
        userId: userDocId,
        code: _inviteCode,
        idToken: _userIdToken,
        email: _postBody['email']);

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
    if (_user.id == null && _user.id.isEmpty) {
      _user.id = await Database().getUserDocId(_user.userUids.first);
    }

    http.Response response = await LokalApiService.instance.user.update(
        data: {"id": _user.id, "registration": _user.registration.toMap()},
        idToken: _userIdToken);
    if (response.statusCode != 200) return false;

    Map data = json.decode(response.body);
    return data["status"] == "ok";
  }

  Future<Map> _getUserInfo(String uid) async {
    String docId = await Database().getUserDocId(uid);
    if (docId != null && docId.isNotEmpty) {
      http.Response response = await LokalApiService.instance.user
          .getById(userId: docId, idToken: _userIdToken);
      if (response.statusCode != 200) return null;

      Map data = json.decode(response.body);
      if (data["status"] == "ok") {
        data["id"] = docId;
        return data;
      }
    }
    return null;
  }

  // Login methods:

  Future<String> onStartUp() async {
    FirebaseAuthStatus retVal = FirebaseAuthStatus.Error;
    try {
      final user = await FirebaseAuthService().startUp();
      retVal = await _validateLogin(user);
    } catch (e) {
      //TODO: do something with error
    }
    return retVal == FirebaseAuthStatus.Success ? "success" : "error";
  }

  Future<String> onSignOut() async {
    String retVal = "error";
    try {
      await FirebaseAuthService().signOut();
      _user = LokalUser();
      retVal = "success";
    } catch (e) {
      print(e);
    }

    notifyListeners();
    return retVal;
  }

  Future<FirebaseAuthStatus> signUpUser(String email, String password) async {
    FirebaseAuthStatus retVal = FirebaseAuthStatus.Error;
    try {
      final user =
          await FirebaseAuthService().signUp(email: email, password: password);

      if (user != null) {
        retVal = FirebaseAuthStatus.UserNotFound;
        _postBody["user_uid"] = user.uid;
        _postBody["email"] = user.email;
        _userIdToken = user.idToken;
      }
    } catch (e) {
      if (e.code == "email-already-in-use") {
        retVal = await loginUserWithEmail(email, password);
      }
    }
    return retVal;
  }

  Future<FirebaseAuthStatus> loginUserWithEmail(
      String email, String password) async {
    FirebaseAuthStatus retVal = FirebaseAuthStatus.Error;

    try {
      final user = await FirebaseAuthService()
          .signInWithEmail(email: email, password: password);
      retVal = await _validateLogin(user);
    } catch (e) {
      switch (e.code) {
        case "invalid-email":
          retVal = FirebaseAuthStatus.UserNotFound;
          break;
        case "wrong-password":
          retVal = FirebaseAuthStatus.PasswordNotValid;
          break;
        case "user-not-found":
          retVal = FirebaseAuthStatus.UserNotFound;
          break;
        default:
          retVal = FirebaseAuthStatus.Error;
      }
    }
    return retVal;
  }

  Future<FirebaseAuthStatus> loginUserWithGoogle() async {
    FirebaseAuthStatus retVal = FirebaseAuthStatus.Error;
    try {
      final user = await FirebaseAuthService().signInWithGoogle();
      retVal = await _validateLogin(user);
    } catch (e) {
      //TODO: do something with error
    }
    return retVal;
  }

  Future<FirebaseAuthStatus> loginUserWithFacebook() async {
    FirebaseAuthStatus retVal = FirebaseAuthStatus.Error;
    try {
      final user = await FirebaseAuthService().signInWithFacebook();
      retVal = await _validateLogin(user);
    } catch (e) {
      //TODO: do something with error
    }
    return retVal;
  }

  Future<FirebaseAuthStatus> _validateLogin(FirebaseUser user) async {
    _userIdToken = user.idToken;
    FirebaseAuthStatus retVal = FirebaseAuthStatus.Error;
    Map map = await _getUserInfo(user.uid);

    if (map != null) {
      _user = LokalUser.fromMap(map["data"]);
      retVal = FirebaseAuthStatus.Success;
      // added to remove states for add shops
      await getShops();
      // since we have one shop, we only need to get all products for the user
      await getUserProducts();

      FirebaseAuth.instance.idTokenChanges().listen((User user) {
        if (user != null) {
          user.getIdToken().then((String token) {
            this._userIdToken = token;
          });
        }
      });
    } else {
      _postBody["user_uid"] = user.uid;
      _postBody["email"] = user.email;
      retVal = FirebaseAuthStatus.UserNotFound;
    }

    return retVal;
  }
}
