import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../models/bank_code.dart';
import '../../../../models/payment_options.dart';
import '../../../../providers/bank_codes.dart';
import '../../../../providers/post_requests/shop_body.dart';
import '../../../../routers/app_router.dart';
import '../../../../state/view_model.dart';

class AddBankDetailsViewModel extends ViewModel {
  AddBankDetailsViewModel(
    this.type,
    this._shopBody,
    this._bankCodes,
    this.formKey, [
    this.initialAccount,
  ]);
  final ShopBody _shopBody;
  final BankCodes _bankCodes;
  final GlobalKey<FormState> formKey;
  final BankType type;
  BankAccount? initialAccount;

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

  @override
  void init() {
    if (initialAccount != null) {
      final accounts = type == BankType.bank
          ? _shopBody.paymentOptions!.bankAccounts
          : _shopBody.paymentOptions!.gCashAccounts;

      final account = accounts.firstWhere((bank) => bank == initialAccount);

      _bank = codes.firstWhere((code) => code.id == account.bank);
      _accountName = account.accountName;
      _accountNumber = account.accountNumber.toString();
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

  void _onAddWalletAccount() {
    final _paymentOptions = _shopBody.paymentOptions ?? const PaymentOptions();
    final _gCashAccounts = [..._paymentOptions.gCashAccounts];
    final _newAccount = WalletAccount(
      bank: _bank!.id,
      accountName: accountName,
      accountNumber: int.parse(accountNumber),
    );

    if (initialAccount != null) {
      _gCashAccounts.removeWhere((account) => account == initialAccount);
    }

    if (_gCashAccounts.contains(_newAccount)) {
      showToast('Wallet has already been added!');
      return;
    }

    final _newPaymentOptions = _paymentOptions.copyWith(
      gCashAccounts: [
        ..._gCashAccounts,
        _newAccount,
      ],
    );
    _shopBody.update(paymentOptions: _newPaymentOptions);
  }

  void _onAddBankAccount() {
    final _paymentOptions = _shopBody.paymentOptions ?? const PaymentOptions();
    final _bankAccounts = [..._paymentOptions.bankAccounts];
    final _newAccount = BankAccount(
      bank: _bank!.id,
      accountName: accountName,
      accountNumber: int.parse(accountNumber),
    );

    if (initialAccount != null) {
      _bankAccounts.removeWhere((account) => account == initialAccount);
    }

    if (_bankAccounts.contains(_newAccount)) {
      showToast('Bank has already been added!');
      return;
    }

    final _newPaymentOptions = _paymentOptions.copyWith(
      bankAccounts: [
        ..._bankAccounts,
        _newAccount,
      ],
    );
    _shopBody.update(paymentOptions: _newPaymentOptions);
  }

  void onAddPaymentAccount() {
    if (!(formKey.currentState?.validate() ?? false)) {
      if (_bank == null) {
        _bankError = 'Bank should not be empty!';
        notifyListeners();
      }
      return;
    }

    if (type == BankType.bank) {
      _onAddBankAccount();
    } else {
      _onAddWalletAccount();
    }

    AppRouter.profileNavigatorKey.currentState?.pop();
  }

  void _onDeleteBankAccount() {
    final _paymentOptions = _shopBody.paymentOptions ?? const PaymentOptions();
    final _bankAccounts = [..._paymentOptions.bankAccounts];
    _bankAccounts.removeWhere((account) => account == initialAccount);
    final _newPaymentOptions = _paymentOptions.copyWith(
      bankAccounts: [..._bankAccounts],
    );
    _shopBody.update(paymentOptions: _newPaymentOptions);
  }

  void _onDeleteWalletAccount() {
    final _paymentOptions = _shopBody.paymentOptions ?? const PaymentOptions();
    final _gCashAccounts = [..._paymentOptions.gCashAccounts];
    _gCashAccounts.removeWhere((account) => account == initialAccount);
    final _newPaymentOptions = _paymentOptions.copyWith(
      gCashAccounts: [..._gCashAccounts],
    );
    _shopBody.update(paymentOptions: _newPaymentOptions);
  }

  void onDeleteAccount() {
    if (initialAccount == null) {
      showToast('No Account found!');
      return;
    }

    if (type == BankType.bank) {
      _onDeleteBankAccount();
    } else {
      _onDeleteWalletAccount();
    }

    AppRouter.profileNavigatorKey.currentState?.pop();
  }

  String? accountNameValidator(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Account Name should not be empty!';
    }
  }

  String? accountNumberValidator(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Account Number should not be empty!';
    }

    if (int.tryParse(value!) == null) {
      return 'Account Number should only contain numbers.';
    }
  }
}
