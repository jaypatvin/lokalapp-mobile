import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/json_converters/bank_type_converter.dart';
import 'bank_code.dart';

part 'payment_option.freezed.dart';
part 'payment_option.g.dart';

@freezed
class PaymentOption with _$PaymentOption {
  const factory PaymentOption({
    required String bankCode,
    required String accountName,
    required String accountNumber,
    @BankTypeConverter() required BankType type,
  }) = _PaymentOption;

  factory PaymentOption.fromJson(Map<String, dynamic> json) =>
      _$PaymentOptionFromJson(json);
}
