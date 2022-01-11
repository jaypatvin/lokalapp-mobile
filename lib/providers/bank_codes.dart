import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

import '../models/bank_code.dart';
import '../services/database.dart';

class BankCodes extends ChangeNotifier {
  final _db = Database.instance;

  List<BankCode> _codes = [];
  UnmodifiableListView<BankCode> get bankCodes =>
      UnmodifiableListView(_codes.where((bank) => bank.type == BankType.bank));
  UnmodifiableListView<BankCode> get walletCodes => UnmodifiableListView(
        _codes.where((bank) => bank.type == BankType.wallet),
      );
  UnmodifiableListView<BankCode> get codes => UnmodifiableListView(_codes);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetch() async {
    _isLoading = true;
    notifyListeners();
    try {
      final _snapshots = await _db.getBankCodes();
      final _codes = <BankCode>[];

      for (final doc in _snapshots.docs) {
        _codes.add(BankCode.fromDocument(doc));
      }
      this._codes = _codes;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  BankCode getById(String id) => _codes.firstWhere((code) => code.id == id);
}
