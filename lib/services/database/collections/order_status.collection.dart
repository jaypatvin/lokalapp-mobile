import 'package:cloud_firestore/cloud_firestore.dart';

import '../collection_impl.dart';

class OrderStatusCollection extends CollectionImpl {
  OrderStatusCollection(super.collection);

  Future<QuerySnapshot<Map<String, dynamic>>> getOrderStatuses() {
    return reference.get();
  }
}
