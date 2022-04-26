import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../app/app.locator.dart';
import '../../../../app/app_router.dart';
import '../../../../models/bank_code.dart';
import '../../../../models/payment_option.dart';
import '../../../../providers/bank_codes.dart';
import '../../../../providers/post_requests/shop_body.dart';
import '../../../../state/view_model.dart';

class AddBankDetailsViewModel extends ViewModel {
  AddBankDetailsViewModel(
    this.type,
    this._shopBody,
    this._bankCodes,
    this.formKey, {
    this.initialAccount,
    this.edit = false,
  });
  final ShopBody _shopBody;
  final BankCodes _bankCodes;
  final GlobalKey<FormState> formKey;
  final BankType type;
  final bool edit;
  PaymentOption? initialAccount;

  BankCode? _bank;
  BankCode? get bank => _bank;

  String _accountName = '';
  String get accountName => _accountName;

  String _accountNumber = '';
  String get accountNumber => _accountNumber;

  String? _bankError;
  String? get bankError => _bankError;

  List<BankCode> get codes =>
      type == BankType.bank ? _bankCodes.bankCodes : _bankCodes.walletCodes;

  final _appRouter = locator<AppRouter>();

  @override
  void init() {
    if (initialAccount != null) {
      final accounts =
          _shopBody.paymentOptions.where((bank) => bank.type == type).toList();

      final account = accounts.firstWhere((bank) => bank == initialAccount);

      _bank = codes.firstWhere((code) => code.id == account.bankCode);
      _accountName = account.accountName;
      _accountNumber = account.accountNumber;
    }
  }

  void onBankChanged(BankCode? bank) {
    _bank = bank;
    notifyListeners();
  }

  void onAccountNameChanged(String value) {
    _accountName = value.trim();
    notifyListeners();
  }

  void onAccountNumberChanged(String value) {
    _accountNumber = value.trim();
    notifyListeners();
  }

  void onAddPaymentAccount() {
    if (!(formKey.currentState?.validate() ?? false)) {
      if (_bank == null) {
        _bankError =
            '${type == BankType.bank ? "Bank" : "Wallet"} should not be empty!';
        notifyListeners();
      }
      return;
    }

    final _paymentOptions = _shopBody.paymentOptions;
    final _initialAccounts = [
      ..._paymentOptions,
    ];
    final _newAccount = PaymentOption(
      bankCode: _bank!.id,
      accountName: accountName,
      accountNumber: accountNumber.trim(),
      type: type,
    );

    if (initialAccount != null) {
      _initialAccounts.removeWhere((account) => account == initialAccount);
    }

    if (_initialAccounts.contains(_newAccount)) {
      showToast(
        '${type == BankType.bank ? "Bank" : "Wallet"} has already been added!',
      );
      return;
    }

    final _newPaymentOptions = [
      ..._initialAccounts,
      _newAccount,
    ];
    _shopBody.update(paymentOptions: _newPaymentOptions);

    _appRouter.popScreen(AppRoute.profile);
  }

  void onDeleteAccount() {
    if (initialAccount == null) {
      showToast('No Account found!');
      return;
    }

    final _paymentOptions = _shopBody.paymentOptions;
    final _initialAccounts = [
      ..._paymentOptions,
    ];
    _initialAccounts.removeWhere((account) => account == initialAccount);
    final _newPaymentOptions = [..._initialAccounts];
    _shopBody.update(paymentOptions: _newPaymentOptions);

    _appRouter.popScreen(AppRoute.profile);
  }

  String? accountNameValidator(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Account Name should not be empty!';
    }
    return null;
  }

  String? accountNumberValidator(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Account Number should not be empty!';
    }

    if (int.tryParse(value!) == null) {
      return 'Account Number should only contain numbers.';
    }

    return null;
  }
}
