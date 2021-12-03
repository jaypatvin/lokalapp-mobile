import 'dart:convert';

import 'package:flutter/foundation.dart';

class PaymentOptions {
  final List<BankAccount> bankAccounts;
  final List<WalletAccount> gCashAccounts;
  const PaymentOptions({
    this.bankAccounts = const <BankAccount>[],
    this.gCashAccounts = const <WalletAccount>[],
  });

  PaymentOptions copyWith({
    List<BankAccount>? bankAccounts,
    List<WalletAccount>? gCashAccounts,
  }) {
    return PaymentOptions(
      bankAccounts: bankAccounts ?? this.bankAccounts,
      gCashAccounts: gCashAccounts ?? this.gCashAccounts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bank_accounts': bankAccounts.map((x) => x.toMap()).toList(),
      'gcash_accounts': gCashAccounts.map((x) => x.toMap()).toList(),
    };
  }

  factory PaymentOptions.fromMap(Map<String, dynamic> map) {
    return PaymentOptions(
      bankAccounts: List<BankAccount>.from(
          map['bank_accounts']?.map((x) => BankAccount.fromMap(x)) ?? []),
      gCashAccounts: List<WalletAccount>.from(
          map['gcash_accounts']?.map((x) => WalletAccount.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentOptions.fromJson(String source) =>
      PaymentOptions.fromMap(json.decode(source));

  @override
  String toString() => 'PaymentOptions(bankAccounts: $bankAccounts, '
      'gCashAccounts: $gCashAccounts)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaymentOptions &&
        listEquals(other.bankAccounts, bankAccounts) &&
        listEquals(other.gCashAccounts, gCashAccounts);
  }

  @override
  int get hashCode => bankAccounts.hashCode ^ gCashAccounts.hashCode;
}

class BankAccount {
  String bank;
  String accountName;
  int accountNumber;
  BankAccount({
    required this.bank,
    required this.accountName,
    required this.accountNumber,
  });

  BankAccount copyWith({
    String? bank,
    String? accountName,
    int? accountNumber,
  }) {
    return BankAccount(
      bank: bank ?? this.bank,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bank': bank,
      'account_name': accountName,
      'account_number': accountNumber,
    };
  }

  @override
  factory BankAccount.fromMap(Map<String, dynamic> map) {
    return BankAccount(
      bank: map['bank'],
      accountName: map['account_name'],
      accountNumber: map['account_number'],
    );
  }

  String toJson() => json.encode(toMap());

  @override
  factory BankAccount.fromJson(String source) =>
      BankAccount.fromMap(json.decode(source));

  @override
  String toString() => 'BankAccount(bank: $bank, accountName: $accountName, '
      'accountNumber: $accountNumber)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BankAccount &&
        other.bank == bank &&
        other.accountName == accountName &&
        other.accountNumber == accountNumber;
  }

  @override
  int get hashCode =>
      bank.hashCode ^ accountName.hashCode ^ accountNumber.hashCode;
}

class WalletAccount extends BankAccount {
  WalletAccount({
    required String bank,
    required String accountName,
    required int accountNumber,
  }) : super(
          accountName: accountName,
          accountNumber: accountNumber,
          bank: bank,
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': accountName,
      'number': accountNumber,
      'bank': bank,
    };
  }

  @override
  factory WalletAccount.fromMap(Map<String, dynamic> map) {
    return WalletAccount(
      accountName: map['name'], // should be required
      accountNumber: map['number'], // should be required
      bank: map['bank'] ?? 'gcash', // defaults to gcash
    );
  }

  @override
  factory WalletAccount.fromJson(String source) =>
      WalletAccount.fromMap(json.decode(source));

  @override
  String toString() =>
      'WalletAccount(name: $accountName, number: $accountNumber, bank: $bank)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WalletAccount &&
        other.accountName == accountName &&
        other.accountNumber == accountNumber &&
        other.bank == bank;
  }

  @override
  int get hashCode =>
      accountName.hashCode ^ accountNumber.hashCode ^ bank.hashCode;
}
