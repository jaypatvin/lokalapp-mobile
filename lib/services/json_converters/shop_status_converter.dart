import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/shop.dart';

class ShopStatusConverter implements JsonConverter<ShopStatus, String> {
  const ShopStatusConverter();

  @override
  ShopStatus fromJson(String status) {
    return ShopStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => ShopStatus.enabled,
    );
  }

  @override
  String toJson(ShopStatus status) => status.value;
}
