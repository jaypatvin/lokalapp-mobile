import 'package:cloud_firestore/cloud_firestore.dart';

import '../collection_impl.dart';
import '../database.dart';

class OrderStatusCollection extends CollectionImpl {
  OrderStatusCollection(Collection collection) : super(collection);

  Future<QuerySnapshot<Map<String, dynamic>>> getOrderStatuses() {
    return reference.get();
  }
}
