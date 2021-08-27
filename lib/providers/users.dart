import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/lokal_user.dart';
import '../services/lokal_api_service.dart';

class Users extends ChangeNotifier {
  List<LokalUser> _users;
  bool _isLoading;
  String _idToken;
  String _communityId;

  List<LokalUser> get users {
    return [..._users];
  }

  bool get isLoading => _isLoading;

  LokalUser findById(String id) {
    return _users.firstWhere((user) => user.id == id);
  }

  void setCommunityId(String id) {
    _communityId = id;
  }

  void setIdToken(String id) {
    _idToken = id;
  }

  void fetch() async {
    _isLoading = true;
    var response = await LokalApiService.instance.user
        .getCommunityUsers(communityId: _communityId, idToken: _idToken);

    if (response.statusCode != 200) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    Map data = json.decode(response.body);

    if (data['status'] == "ok") {
      List<LokalUser> users = [];
      for (var product in data['data']) {
        var _product = LokalUser.fromMap(product);
        users.add(_product);
      }
      _users = users;
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _users = [];

    notifyListeners();
  }
}
