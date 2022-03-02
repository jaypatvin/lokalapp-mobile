import '../../../models/bank_code.dart';
import '../collection_impl.dart';
import '../database.dart';

class BankCodesCollection extends CollectionImpl {
  BankCodesCollection(Collection collection) : super(collection);

  Future<List<BankCode>> getBankCodes() async {
    final _snapshot = await reference.get();

    return _snapshot.docs
        .map<BankCode>((doc) => BankCode.fromDocument(doc))
        .toList();
  }

  Stream<List<BankCode>> getBankCodesStream() {
    return reference
        .snapshots()
        .map((e) => e.docs.map((doc) => BankCode.fromDocument(doc)).toList());
  }
}
