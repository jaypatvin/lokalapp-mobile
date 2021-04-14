import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/lokal_user.dart';
import '../services/lokal_api_service.dart';

class Users extends ChangeNotifier {
  List<LokalUser> _users;
  bool _isLoading;

  List<LokalUser> get users {
    return [..._users];
  }

  bool get isLoading => _isLoading;

  LokalUser findById(String id) {
    return _users.firstWhere((user) => user.id == id);
  }

  void fetch(String communityId, String idToken) async {
    _isLoading = true;
    var response = await LokalApiService.instance.user
        .getCommunityUsers(communityId: communityId, idToken: idToken);

    if (response.statusCode != 200) {
      _isLoading = false;
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
