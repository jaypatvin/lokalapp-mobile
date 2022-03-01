import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';

import '../models/bank_code.dart';
import '../services/database/collections/bank_codes.collection.dart';
import '../services/database/database.dart';

class BankCodes extends ChangeNotifier {
  BankCodes(Database database) : _db = database.bankCodes;

  final BankCodesCollection _db;
  List<BankCode> _codes = [];
  UnmodifiableListView<BankCode> get bankCodes =>
      UnmodifiableListView(_codes.where((bank) => bank.type == BankType.bank));

  UnmodifiableListView<BankCode> get walletCodes => UnmodifiableListView(
      // ignore: require_trailing_commas
      _codes.where((bank) => bank.type == BankType.wallet));

  UnmodifiableListView<BankCode> get codes => UnmodifiableListView(_codes);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetch() async {
    _isLoading = true;
    notifyListeners();
    try {
      _codes = await _db.getBankCodes();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      showToast(e.toString());
      // don't do anything
    }
  }

  BankCode getById(String id) => _codes.firstWhere((code) => code.id == id);
}
