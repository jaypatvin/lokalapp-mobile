import 'dart:convert';

import 'bank_code.dart';

class PaymentOption {
  String bankCode;
  String accountName;
  String accountNumber;
  BankType type;
  PaymentOption({
    required this.bankCode,
    required this.accountName,
    required this.accountNumber,
    required this.type,
  });

  PaymentOption copyWith({
    String? bank,
    String? accountName,
    String? accountNumber,
    BankType? type,
  }) {
    return PaymentOption(
      bankCode: bank ?? bankCode,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bank_code': bankCode,
      'account_name': accountName,
      'account_number': accountNumber,
      'type': type.value,
    };
  }

  @override
  factory PaymentOption.fromMap(Map<String, dynamic> map) {
    return PaymentOption(
      bankCode: map['bank_code'],
      accountName: map['account_name'],
      accountNumber: map['account_number'],
      type:
          map['type'] == BankType.bank.value ? BankType.bank : BankType.wallet,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  factory PaymentOption.fromJson(String source) =>
      PaymentOption.fromMap(json.decode(source));

  @override
  String toString() =>
      'BankAccount(bank: $bankCode, accountName: $accountName, '
      'accountNumber: $accountNumber, type: ${type.value})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaymentOption &&
        other.bankCode == bankCode &&
        other.accountName == accountName &&
        other.accountNumber == accountNumber &&
        other.type == type;
  }

  @override
  int get hashCode =>
      bankCode.hashCode ^
      accountName.hashCode ^
      accountNumber.hashCode ^
      type.hashCode;
}
