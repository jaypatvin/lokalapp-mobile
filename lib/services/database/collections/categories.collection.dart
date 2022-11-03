import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../../models/lokal_category.dart';
import '../collection_impl.dart';
import '../database.dart';

class CategoriesCollection extends CollectionImpl {
  CategoriesCollection(Collection collection) : super(collection);

  Future<List<LokalCategory>> getCategories() async {
    final snapshot = await reference.get();

    return snapshot.docs
        .map<LokalCategory?>(_toElement)
        .whereType<LokalCategory>()
        .toList();
  }

  Stream<List<LokalCategory>> getCategoriesStream() {
    return reference.snapshots().map(
          (e) => e.docs
              .map<LokalCategory?>(_toElement)
              .whereType<LokalCategory>()
              .toList(),
        );
  }

  LokalCategory? _toElement(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      return LokalCategory.fromDocument(doc);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return null;
    }
  }
}
