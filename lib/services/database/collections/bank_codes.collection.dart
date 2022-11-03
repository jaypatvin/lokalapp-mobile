import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../../models/bank_code.dart';
import '../collection_impl.dart';
import '../database.dart';

class BankCodesCollection extends CollectionImpl {
  BankCodesCollection(Collection collection) : super(collection);

  Future<List<BankCode>> getBankCodes() async {
    final snapshot = await reference.get();

    return snapshot.docs
        .map<BankCode?>(_toElement)
        .whereType<BankCode>()
        .toList();
  }

  Stream<List<BankCode>> getBankCodesStream() {
    return reference.snapshots().map(
          (e) =>
              e.docs.map<BankCode?>(_toElement).whereType<BankCode>().toList(),
        );
  }

  BankCode? _toElement(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      return BankCode.fromDocument(doc);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return null;
    }
  }
}
