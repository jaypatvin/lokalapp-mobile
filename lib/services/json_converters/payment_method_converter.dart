import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/order.dart';

class PaymentMethodOrNullConverter
    implements JsonConverter<PaymentMethod?, String?> {
  const PaymentMethodOrNullConverter();

  @override
  PaymentMethod? fromJson(String? value) {
    return PaymentMethod.values.firstWhereOrNull((e) => e.value == value);
  }

  @override
  String? toJson(PaymentMethod? method) => method?.value;
}

class PaymentMethodConverter implements JsonConverter<PaymentMethod, String> {
  const PaymentMethodConverter();

  @override
  PaymentMethod fromJson(String? value) {
    return PaymentMethod.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PaymentMethod.cod,
    );
  }

  @override
  String toJson(PaymentMethod? method) =>
      method?.value ?? PaymentMethod.cod.value;
}
