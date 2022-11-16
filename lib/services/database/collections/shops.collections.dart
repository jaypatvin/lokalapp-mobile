import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../../models/shop.dart';
import '../collection_impl.dart';

class ShopsCollection extends CollectionImpl {
  ShopsCollection(super.collection);

  Stream<List<Shop>> getCommunityShops(
    String communityId,
  ) {
    return reference
        .where('community_id', isEqualTo: communityId)
        .snapshots()
        .map(
          (e) => e.docs
              .map<Shop?>((doc) {
                try {
                  return Shop.fromDocument(doc);
                } catch (e, stack) {
                  FirebaseCrashlytics.instance.recordError(e, stack);
                  return null;
                }
              })
              .whereType<Shop>()
              .toList(),
        );
  }
}
