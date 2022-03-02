import '../../../models/shop.dart';
import '../collection_impl.dart';
import '../database.dart';

class ShopsCollection extends CollectionImpl {
  ShopsCollection(Collection collection) : super(collection);

  Stream<List<Shop>> getCommunityShops(
    String communityId,
  ) {
    return reference
        .where('community_id', isEqualTo: communityId)
        .snapshots()
        .map((e) => e.docs.map((doc) => Shop.fromDocument(doc)).toList());
  }
}
