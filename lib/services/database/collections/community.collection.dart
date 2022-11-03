import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../../models/community.dart';
import '../collection_impl.dart';
import '../database.dart';

class CommunityCollection extends CollectionImpl {
  CommunityCollection(Collection collection) : super(collection);

  Future<Community?> getCommunity(String id) async {
    final doc = await reference.doc(id).get();
    if (!doc.exists) return null;

    try {
      return Community.fromDocument(doc);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return null;
    }
  }

  Stream<Community> getCommunityStream(String id) {
    return reference
        .doc(id)
        .snapshots()
        .map((doc) => Community.fromDocument(doc));
  }
}
