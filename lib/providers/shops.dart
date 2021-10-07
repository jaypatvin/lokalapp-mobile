import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/user_shop.dart';
import '../services/lokal_api_service.dart';

class Shops extends ChangeNotifier {
  String _communityId;
  String _idToken;
  List<ShopModel> _shops = [];
  bool _isLoading;

  bool get isLoading => _isLoading;
  List<ShopModel> get items {
    return [..._shops];
  }

  String get communityId => _communityId;

  void setCommunityId(String id) {
    _communityId = id;
  }

  void setIdToken(String id) {
    _idToken = id;
  }

  ShopModel findById(String id) {
    return _shops.firstWhere((shop) => shop.id == id, orElse: () => null);
  }

  List<ShopModel> findByUser(String userId) {
    return _shops.where((shop) => shop.userId == userId).toList();
  }

  Future<void> fetch() async {
    _isLoading = true;
    var response = await LokalApiService.instance.shop
        .getShopsByCommunity(communityId: communityId, idToken: _idToken);

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

  Future<bool> create(Map data) async {
    try {
      var response = await LokalApiService.instance.shop
          .create(data: data, idToken: _idToken);

      if (response.statusCode != 200) return false;

      Map body = json.decode(response.body);

      if (body['status'] == 'ok') {
        var shop = ShopModel.fromMap(data["data"]);
        _shops.add(shop);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> update({
    @required String id,
    @required Map data,
  }) async {
    try {
      var response = await LokalApiService.instance.shop
          .update(id: id, data: data, idToken: _idToken);

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

  Future<bool> setOperatingHours(
      {@required String id, @required Map data}) async {
    try {
      var response = await LokalApiService.instance.shop
          .setOperatingHours(data: data, idToken: _idToken, id: id);

      if (response.statusCode != 200) return false;

      Map body = json.decode(response.body);

      if (body['status'] == 'ok') {
        // call fetch manually?
        // or getOperatingHours
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
