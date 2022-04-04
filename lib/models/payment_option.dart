import 'package:json_annotation/json_annotation.dart';

import 'bank_code.dart';

part 'payment_option.g.dart';

@JsonSerializable()
class PaymentOption {
  const PaymentOption({
    required this.bankCode,
    required this.accountName,
    required this.accountNumber,
    required this.type,
  });

  @JsonKey(required: true)
  final String bankCode;
  @JsonKey(required: true)
  final String accountName;
  @JsonKey(required: true)
  final String accountNumber;
  @JsonKey(required: true, fromJson: _bankTypeFromJson, toJson: _bankTypeToJson)
  final BankType type;

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

  Map<String, dynamic> toJson() => _$PaymentOptionToJson(this);
  factory PaymentOption.fromJson(Map<String, dynamic> json) =>
      _$PaymentOptionFromJson(json);

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

BankType _bankTypeFromJson(String bankType) {
  return BankType.values.firstWhere(
    (e) => e.value == bankType,
    orElse: () => BankType.bank,
  );
}

String _bankTypeToJson(BankType type) => type.value;
