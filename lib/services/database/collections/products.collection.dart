import '../../../models/product.dart';
import '../collection_impl.dart';
import '../database.dart';

class ProductsCollection extends CollectionImpl {
  ProductsCollection(Collection collection) : super(collection);

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
        .map((e) => e.docs.map((doc) => Product.fromDocument(doc)).toList());
  }
}
