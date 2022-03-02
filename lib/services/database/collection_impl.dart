import 'package:cloud_firestore/cloud_firestore.dart';

import 'database.dart';

abstract class CollectionImpl {
  CollectionImpl(this.collection)
      : reference = FirebaseFirestore.instance.collection(collection.path);

  final Collection collection;
  final CollectionReference<Map<String, dynamic>> reference;
}
