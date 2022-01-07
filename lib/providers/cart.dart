import 'dart:collection';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';

enum DeliveryOption { pickup, delivery }

extension DeliveryOptionExtension on DeliveryOption {
  String get value {
    switch (this) {
      case DeliveryOption.delivery:
        return 'delivery';
      case DeliveryOption.pickup:
      default:
        return 'pickup';
    }
  }
}

class ProductOrderDetails {
  /// The number of items to be ordered
  final int quantity;

  /// Any special instructions for the seller
  final String? notes;

  /// Either customer pick-up or for seller delivery
  final DeliveryOption deliveryOption;

  /// When to pickup/deliver
  final DateTime? schedule;

  /// Details of product order
  const ProductOrderDetails({
    required this.quantity,
    required this.notes,
    this.deliveryOption = DeliveryOption.pickup,
    this.schedule,
  });
}

class ShoppingCart extends ChangeNotifier {
  final Map<String?, Map<String?, ProductOrderDetails>> _orders = {};

  /// The orders is a Map with a Key of `shopId`
  /// and a value of `Map<"productId", ProductOrderDetails>`
  Map<String?, Map<String?, ProductOrderDetails>> get orders =>
      UnmodifiableMapView(_orders);

  /// Checks if the cart already contains a specific productId
  bool contains(String? productId) {
    return _orders.values.any((orders) => orders.containsKey(productId));
  }

  /// Returns a particular order by `<productId, ProductOrderDetails>`
  ProductOrderDetails? getProductOrder(String? productId) {
    final shopOrder = _getOrderEntry(productId);
    if (shopOrder == null) return null;
    return _orders[shopOrder.key]![productId];
  }

  /// Adds a new entry to ShopOrders with a required quantity
  ///
  /// If the quantity is set to 0, removes the product entry.
  /// Can also be used as a substitute to `updateOrder()` while being more optimized.
  ///
  /// The `deliveryOption` is set to `DeliveryOption.pickup` by default.
  void add({
    required String? shopId,
    required String? productId,
    required int quantity,
    String? notes,
    DeliveryOption deliveryOption = DeliveryOption.pickup,
    DateTime? schedule,
  }) {
    if (_orders[shopId] == null) {
      _orders[shopId] = <String?, ProductOrderDetails>{};
    }

    if (quantity == 0) {
      remove(productId);
      return;
    }

    _orders[shopId]![productId] = ProductOrderDetails(
      quantity: quantity,
      notes: notes,
      deliveryOption: deliveryOption,
      schedule: schedule,
    );
    notifyListeners();
  }

  /// Updates a product entry.
  /// `productId is` required.
  ///
  /// If the quantity is set to 0, removes the product entry.
  /// Can also be used as a substitute to `add()` but this is a more expensive operation
  void updateOrder({
    required String? productId,
    int? quantity,
    String? notes,
    DeliveryOption? deliveryOption,
    DateTime? schedule,
  }) {
    final shopOrder = _getOrderEntry(productId);
    if (shopOrder == null) return;

    final key = shopOrder.key;
    if (_orders[key] == null) {
      _orders[key] = <String?, ProductOrderDetails>{};
    }

    if (quantity == 0) {
      remove(productId);
      return;
    }

    final order = _orders[key]![productId];
    _orders[key]![productId] = ProductOrderDetails(
      quantity: quantity ?? order!.quantity,
      notes: notes ?? order!.notes,
      deliveryOption: deliveryOption ?? order!.deliveryOption,
      schedule: schedule ?? order!.schedule,
    );

    notifyListeners();
  }

  /// Removes a MapEntry from the orders
  ///
  /// If the corresponding Shop has no remaining orders, remove it from the map.
  void remove(String? productId) {
    final order = _getOrderEntry(productId);
    if (order == null) return;
    _orders[order.key]!.remove(productId);

    if (_orders[order.key]!.isEmpty) {
      _orders.remove(order.key);
    }
    notifyListeners();
  }

  /// Clears the cart.
  void clear() {
    _orders.clear();
    notifyListeners();
  }

  MapEntry<String?, Map<String?, ProductOrderDetails>>? _getOrderEntry(
    String? productId,
  ) {
    return _orders.entries.singleWhereOrNull(
      (orders) => orders.value.containsKey(productId),
    );
  }
}
