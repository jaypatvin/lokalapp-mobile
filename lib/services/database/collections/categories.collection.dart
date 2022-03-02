import '../../../models/lokal_category.dart';
import '../collection_impl.dart';
import '../database.dart';

class CategoriesCollection extends CollectionImpl {
  CategoriesCollection(Collection collection) : super(collection);

  Future<List<LokalCategory>> getCategories() async {
    final _snapshot = await reference.get();

    return _snapshot.docs
        .map<LokalCategory>((doc) => LokalCategory.fromDocument(doc))
        .toList();
  }

  Stream<List<LokalCategory>> getCategoriesStream() {
    return reference.snapshots().map(
          (e) => e.docs.map((doc) => LokalCategory.fromDocument(doc)).toList(),
        );
  }
}
