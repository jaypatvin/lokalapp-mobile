import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../models/user_shop.dart';
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
  List<ShopModel> _shops = [];
  bool _isLoading = false;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _shopsSubscription;

  bool get isLoading => _isLoading;
  UnmodifiableListView<ShopModel> get items => UnmodifiableListView(_shops);
  String? get communityId => _communityId;

  void setCommunityId(String? id) {
    if (id != null) {
      if (id == _communityId) return;
      _communityId = id;
      _shopsSubscription?.cancel();
      _shopsSubscription = _db.getCommunityShops(id).listen(_shopListener);
    }
  }

  Future<void> _shopListener(QuerySnapshot<Map<String, dynamic>> query) async {
    final length = query.docChanges.length;
    if (_isLoading || length > 1) return;
    for (final change in query.docChanges) {
      final id = change.doc.id;
      final index = _shops.indexWhere((s) => s.id == id);

      if (index >= 0) {
        _shops[index] = await _apiService.getById(id: id);
        if (hasListeners) notifyListeners();
        return;
      }

      final shop = await _apiService.getById(id: id);
      _shops.add(shop);
      if (hasListeners) notifyListeners();
    }
  }

  ShopModel? findById(String? id) {
    return _shops.firstWhereOrNull((shop) => shop.id == id);
  }

  List<ShopModel> findByUser(String? userId) {
    return _shops.where((shop) => shop.userId == userId).toList();
  }

  Future<void> fetch() async {
    _isLoading = true;
    notifyListeners();

    try {
      _shops = await _apiService.getCommunityShops(
        communityId: _communityId!,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
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
