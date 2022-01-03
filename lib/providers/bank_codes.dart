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
      _codes.where((bank) => bank.type == BankType.wallet));
  UnmodifiableListView<BankCode> get codes => UnmodifiableListView(_codes);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetch() async {
    _isLoading = true;
    notifyListeners();
    try {
      final _snapshots = await _db.getBankCodes();
      final _codes = <BankCode>[];

      _snapshots.docs.forEach((doc) {
        _codes.add(BankCode.fromDocument(doc));
      });
      this._codes = _codes;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  BankCode getById(String id) => _codes.firstWhere((code) => code.id == id);
}