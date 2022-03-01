import 'package:cloud_firestore/cloud_firestore.dart';

import '../collection_impl.dart';
import '../database.dart';

class OrdersCollection extends CollectionImpl {
  OrdersCollection(Collection collection) : super(collection);

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserOrders(
    String? userId, {
    int? statusCode,
  }) {
    if (statusCode != null) {
      return reference
          .where('buyer_id', isEqualTo: userId)
          .where('status_code', isEqualTo: statusCode)
          .orderBy('created_at', descending: true)
          .snapshots();
    }

    return reference
        .where('buyer_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getShopOrders(
    String? shopId, {
    int? statusCode,
  }) {
    if (statusCode != null) {
      return reference
          .where('shop_id', isEqualTo: shopId)
          .where('status_code', isEqualTo: statusCode)
          .orderBy('created_at', descending: true)
          .snapshots();
    }
    return reference
        .where('shop_id', isEqualTo: shopId)
        .orderBy('created_at', descending: true)
        .snapshots();
  }
}
