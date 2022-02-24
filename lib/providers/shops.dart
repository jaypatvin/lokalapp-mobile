import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../models/shop.dart';
import '../services/api/api.dart';
import '../services/api/shop_api_service.dart';
import '../services/database.dart';

class Shops extends ChangeNotifier {
  factory Shops(API api) {
    return Shops._(ShopAPIService(api));
  }

  Shops._(this._apiService);

  final ShopAPIService _apiService;
  final Database _db = Database.instance;

  String? _communityId;
  List<Shop> _shops = [];
  bool _isLoading = false;

  Stream<List<Shop>>? _shopStream;
  Stream<List<Shop>>? get stream => _shopStream;
  StreamSubscription<List<Shop>>? _shopsSubscription;
  StreamSubscription<List<Shop>>? get subscriptionListener =>
      _shopsSubscription;

  // StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _shopsSubscription;
  // StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  //     get subscriptionListener => _shopsSubscription;

  bool get isLoading => _isLoading;
  UnmodifiableListView<Shop> get items => UnmodifiableListView(_shops);
  String? get communityId => _communityId;

  void setCommunityId(String? id) {
    if (id == _communityId) return;
    _communityId = id;

    _communityId = id;
    if (_communityId == null) {
      _shopsSubscription?.cancel();
      _shops.clear();
      if (hasListeners) notifyListeners();
      return;
    }

    if (id != null) {
      _isLoading = true;
      if (hasListeners) notifyListeners();
      _shopsSubscription?.cancel();
      _shopStream = _db.getCommunityShops(id).map((event) {
        return event.docs.map((doc) => Shop.fromDocument(doc)).toList();
      });
      _shopsSubscription = _shopStream?.listen(_shopListener);
    }
  }

  void _shopListener(List<Shop> shops) {
    _shops = shops;
    _isLoading = false;
    if (hasListeners) notifyListeners();
  }

  Shop? findById(String? id) {
    return _shops.firstWhereOrNull((shop) => shop.id == id);
  }

  List<Shop> findByUser(String? userId) {
    return _shops.where((shop) => shop.userId == userId).toList();
  }

  Future<void> create(Map<String, dynamic> body) async {
    try {
      final _shop = await _apiService.create(body: body);
      _shops.add(_shop);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> update({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      return await _apiService.update(id: id, body: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> setOperatingHours({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      return await _apiService.setOperatingHours(id: id, body: data);
    } catch (e) {
      rethrow;
    }
  }
}
