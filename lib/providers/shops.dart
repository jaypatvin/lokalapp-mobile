import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/user_shop.dart';
import '../services/lokal_api_service.dart';

class Shops extends ChangeNotifier {
  String _communityId;
  //String _currentUserId;
  List<ShopModel> _shops = [];
  bool _isLoading;

  bool get isLoading => _isLoading;
  List<ShopModel> get items {
    return [..._shops];
  }

  String get communityId => _communityId;
  // List<ShopModel> get currentUserShops =>
  //     _shops.where((shop) => shop.userId == _currentUserId);

  void setCommunityId(String id) {
    _communityId = id;
  }

  // void setCurrentUserId(String id) {
  //   _currentUserId = id;
  // }

  ShopModel findById(String id) {
    return _shops.firstWhere((shop) => shop.id == id);
  }

  List<ShopModel> findByUser(String userId) {
    return _shops.where((shop) => shop.userId == userId).toList();
  }

  Future<void> fetch(String authToken) async {
    _isLoading = true;
    var response = await LokalApiService.instance.shop
        .getShopsByCommunity(communityId: communityId, idToken: authToken);

    if (response.statusCode != 200) {
      _isLoading = false;
      return;
    }

    Map data = json.decode(response.body);

    if (data["status"] == "ok") {
      List<ShopModel> shops = [];
      for (var shopData in data['data']) {
        var shop = ShopModel.fromMap(shopData);
        shops.add(shop);
      }
      _shops = shops;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> create(String authToken, Map data) async {
    try {
      var response = await LokalApiService.instance.shop
          .create(data: data, idToken: authToken);

      if (response.statusCode != 200) return false;

      Map body = json.decode(response.body);

      if (body['status'] == 'ok') {
        //await fetch(authToken);
        // call fetch manually
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> update({
    @required String id,
    @required String authToken,
    @required Map data,
  }) async {
    try {
      var response = await LokalApiService.instance.shop
          .update(id: id, data: data, idToken: authToken);

      if (response.statusCode != 200) return false;

      Map body = json.decode(response.body);

      if (body['status'] == 'ok') {
        //await fetch(authToken);
        // call fetch manually
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
