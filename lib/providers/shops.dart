import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../models/post_requests/shop/operating_hours.request.dart';
import '../models/post_requests/shop/shop_create.request.dart';
import '../models/post_requests/shop/shop_summary.request.dart';
import '../models/post_requests/shop/shop_update.request.dart';
import '../models/shop.dart';
import '../models/shop_summary.dart';
import '../services/api/api.dart';
import '../services/api/shop_api_service.dart';
import '../services/database/collections/shops.collections.dart';
import '../services/database/database.dart';

class Shops extends ChangeNotifier {
  factory Shops(API api, Database database) {
    return Shops._(ShopAPIService(api), database.shops);
  }

  Shops._(this._apiService, this._db);

  final ShopAPIService _apiService;
  late final ShopsCollection _db;

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
      _shopStream = _db.getCommunityShops(id);
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

  Future<void> create(ShopCreateRequest request) async {
    try {
      final _shop = await _apiService.create(request: request);
      _shops.add(_shop);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> update({
    required String id,
    required ShopUpdateRequest request,
  }) async {
    try {
      return await _apiService.update(id: id, request: request);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> setOperatingHours({
    required String id,
    required OperatingHoursRequest request,
  }) async {
    try {
      return await _apiService.setOperatingHours(id: id, request: request);
    } catch (e) {
      rethrow;
    }
  }

  Future<ShopSummary> shopSummary(
    String shopId, {
    ShopSummaryRequest? request,
  }) =>
      _apiService.shopSummary(
        shopId,
        request: request ??
            ShopSummaryRequest(
              minDate: DateTime(2000),
              maxDate: DateTime.now(),
            ),
      );
}
