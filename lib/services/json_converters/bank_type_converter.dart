import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/bank_code.dart';

class BankTypeConverter implements JsonConverter<BankType, String> {
  const BankTypeConverter();

  @override
  BankType fromJson(String bankType) {
    return BankType.values.firstWhere(
      (e) => e.value == bankType,
      orElse: () => BankType.bank,
    );
  }

  @override
  String toJson(BankType bankType) => bankType.value;
}
