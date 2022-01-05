import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../models/user_shop.dart';
import '../../providers/auth.dart';
import '../../providers/shops.dart';
import '../../routers/app_router.dart';
import '../../screens/activity/subscriptions/subscriptions.dart';
import '../../services/database.dart';
import '../../state/view_model.dart';

class TransactionsViewModel extends ViewModel {
  TransactionsViewModel(
    this.initialStatuses, {
    this.isBuyer = true,
  });

  final Map<int, String?> initialStatuses;
  final bool isBuyer;

  final _statuses = <int, String?>{};
  UnmodifiableMapView<int, String?> get statuses =>
      UnmodifiableMapView(_statuses);

  final Map<int, Stream<QuerySnapshot>> _streams = {};
  UnmodifiableMapView<int, Stream<QuerySnapshot>> get streams =>
      UnmodifiableMapView(_streams);

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  Stream<QuerySnapshot>? _stream;
  Stream<QuerySnapshot>? get stream => _stream;

  late final String subHeader;
  late final String subscriptionSubtitle;
  late final String noOrderMessage;

  // final String noOrderMessage = 'You have no orders yet!';

  final _db = Database.instance;

  ShopModel? shop;

  @override
  void init() {
    this._initializeStatuses();
    this._selectedIndex = _statuses.keys.first;
    this._initializeStreams();
    _stream = _streams[_selectedIndex];

    this.subHeader = isBuyer
        ? 'These are the products you ordered from other stores.'
        : 'These are the products other people ordered from your stores.';
    this.subscriptionSubtitle = isBuyer ? 'Subscriptions' : 'Subscriber Orders';

    this.noOrderMessage = shop != null || isBuyer
        ? 'You have no orders yet!'
        : 'You have not created a shop yet!';
  }

  void _initializeStatuses() {
    final _statusCodes = this.initialStatuses.keys.toList().map((key) {
      if (key == 10 || key == 20) {
        // We're multiplying statuses 10 and 20 (cancelled & declined orders)
        // by 100 to put them in the bottom of the list (after sorting).
        // This will make it easier to display each statuses as filters on top
        // from the most urgent to the least
        key *= 100;
      }
      return key;
    }).toList()
      ..sort();

    this._statuses[0] = "All";
    _statusCodes.forEach((code) {
      // Reverse the multiplication from above to get the correct string value
      // from the firestore collection of statuses
      final _key = (code == 1000 || code == 2000) ? code ~/ 100 : code;
      this._statuses[code] = this.initialStatuses[_key];
    });
  }

  void _initializeStreams() {
    final userId = context.read<Auth>().user!.id;
    for (final key in _statuses.keys) {
      final statusCode = (key == 1000 || key == 2000) ? key ~/ 100 : key;
      if (isBuyer) {
        _streams[key] = _db.getUserOrders(
          userId,
          statusCode: statusCode == 0 ? null : statusCode,
        );
      } else {
        final shops = context.read<Shops>().findByUser(userId);
        if (shops.isEmpty) return;

        final shop = this.shop = shops.first;
        _streams[key] = _db.getShopOrders(
          shop.id,
          statusCode: statusCode == 0 ? null : statusCode,
        );
      }
    }
  }

  void changeIndex(int key) {
    if (key == this.selectedIndex) return;

    this._selectedIndex = key;
    this._stream = _streams[key];

    notifyListeners();
  }

  void onGoToSubscriptionHandler() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => Subscriptions(
          isBuyer: isBuyer,
        ),
      ),
    );
  }

  void createShopHandler() {
    context.read<AppRouter>().jumpToTab(AppRoute.profile);
  }
}
