import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../../models/product_subscription_plan.dart';
import '../collection_impl.dart';
import '../database.dart';

class ProductSubscriptionPlansCollection extends CollectionImpl {
  ProductSubscriptionPlansCollection(Collection collection) : super(collection);

  Stream<List<ProductSubscriptionPlan>> getUserSubscriptionPlans(
    String? userId,
  ) {
    return reference
        .where('buyer_id', isEqualTo: userId)
        .snapshots()
        .map(_convertTo);
  }

  Stream<List<ProductSubscriptionPlan>> getShopSubscriptionPlans(
    String? shopId,
  ) {
    return reference
        .where('shop_id', isEqualTo: shopId)
        .snapshots()
        .map(_convertTo);
  }

  List<ProductSubscriptionPlan> _convertTo(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    return snapshot.docs
        .map<ProductSubscriptionPlan?>((doc) {
          try {
            return ProductSubscriptionPlan.fromDocument(doc);
          } catch (e, stack) {
            FirebaseCrashlytics.instance.recordError(e, stack);
            return null;
          }
        })
        .whereType<ProductSubscriptionPlan>()
        .toList();
  }
}
