
import '../../../models/product_subscription_plan.dart';
import '../collection_impl.dart';
import '../database.dart';

class ProductSubscriptionPlansCollection extends CollectionImpl {
  ProductSubscriptionPlansCollection(Collection collection) : super(collection);

  Stream<List<ProductSubscriptionPlan>> getUserSubscriptionPlans(
    String? userId,
  ) {
    return reference.where('buyer_id', isEqualTo: userId).snapshots().map((e) {
      return e.docs
          .map((doc) => ProductSubscriptionPlan.fromDocument(doc))
          .toList();
    });
  }

  Stream<List<ProductSubscriptionPlan>> getShopSubscriptionPlans(
    String? shopId,
  ) {
    return reference.where('shop_id', isEqualTo: shopId).snapshots().map((e) {
      return e.docs
          .map((doc) => ProductSubscriptionPlan.fromDocument(doc))
          .toList();
    });
  }
}
