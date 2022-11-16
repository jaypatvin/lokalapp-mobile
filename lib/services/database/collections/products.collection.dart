import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../../models/product.dart';
import '../../../models/product_review.dart';
import '../collection_impl.dart';

class ProductsCollection extends CollectionImpl {
  ProductsCollection(super.collection);

  Future<bool> isProductLiked({
    required String productId,
    required String userId,
  }) async {
    final snapshot = await reference
        .doc(productId)
        .collection('likes')
        .where('user_id', isEqualTo: userId)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<List<String>> getProductLikes(String productId) async {
    final snapshot = await reference.doc(productId).collection('likes').get();

    return snapshot.docs
        .map<String?>((doc) {
          final data = doc.data();
          return data['user_id'];
        })
        .whereType<String>()
        .toList();
  }

  Stream<List<Product>> getCommunityProducts(
    String communityId,
  ) {
    return reference
        .where('community_id', isEqualTo: communityId)
        .snapshots()
        .map(
          (e) => e.docs
              .map<Product?>((doc) {
                try {
                  return Product.fromDocument(doc);
                } catch (e, stack) {
                  FirebaseCrashlytics.instance.recordError(e, stack);
                  return null;
                }
              })
              .whereType<Product>()
              .toList(),
        );
  }

  Future<List<ProductReview>> getProductReviews(String productId) async {
    final snapshot = await reference.doc(productId).collection('reviews').get();

    return snapshot.docs
        .map<ProductReview>((doc) => ProductReview.fromJson(doc.data()))
        .toList();
  }
}
