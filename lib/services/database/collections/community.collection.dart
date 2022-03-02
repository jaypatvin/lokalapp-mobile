import '../../../models/community.dart';
import '../collection_impl.dart';
import '../database.dart';

class CommunityCollection extends CollectionImpl {
  CommunityCollection(Collection collection) : super(collection);

  Future<Community?> getCommunity(String id) async {
    final _doc = await reference.doc(id).get();
    if (!_doc.exists) return null;

    return Community.fromDocument(_doc);
  }

  Stream<Community> getCommunityStream(String id) {
    return reference
        .doc(id)
        .snapshots()
        .map((doc) => Community.fromDocument(doc));
  }
}
