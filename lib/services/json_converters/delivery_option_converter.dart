import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/order.dart';

class DeliveryOptionConverter
    implements JsonConverter<DeliveryOption, String?> {
  const DeliveryOptionConverter();

  @override
  DeliveryOption fromJson(String? value) {
    return DeliveryOption.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DeliveryOption.pickup,
    );
  }

  @override
  String? toJson(DeliveryOption? option) => option?.value;
}
