import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../utils/functions.utils.dart';
import '../../order.dart';

part 'order_create.request.g.dart';

@JsonSerializable()
class OrderCreateProduct {
  const OrderCreateProduct({
    required this.id,
    required this.quantity,
    this.instruction,
  });
  final String id;
  final int quantity;
  final String? instruction;

  Map<String, dynamic> toJson() => _$OrderCreateProductToJson(this);
  factory OrderCreateProduct.fromJson(Map<String, dynamic> json) =>
      _$OrderCreateProductFromJson(json);
}

@JsonSerializable()
class OrderCreateRequest {
  const OrderCreateRequest({
    required this.products,
    this.buyerId,
    required this.shopId,
    required this.deliveryOption,
    required this.deliveryDate,
    this.instruction,
  });

  final List<OrderCreateProduct> products;
  final String? buyerId;
  final String shopId;
  @JsonKey(toJson: _deliveryOptionToJson, fromJson: _deliveryOptionFromJson)
  final DeliveryOption deliveryOption;
  @JsonKey(toJson: dateTimeToString, fromJson: createdAtFromJson)
  final DateTime deliveryDate;
  final String? instruction;

  Map<String, dynamic> toJson() => _$OrderCreateRequestToJson(this);
  factory OrderCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderCreateRequestFromJson(json);

  OrderCreateRequest copyWith({
    List<OrderCreateProduct>? products,
    String? buyerId,
    String? shopId,
    DeliveryOption? deliveryOption,
    DateTime? deliveryDate,
    String? instruction,
  }) {
    return OrderCreateRequest(
      products: products ?? this.products,
      buyerId: buyerId ?? this.buyerId,
      shopId: shopId ?? this.shopId,
      deliveryOption: deliveryOption ?? this.deliveryOption,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      instruction: instruction ?? this.instruction,
    );
  }

  @override
  String toString() {
    return 'OrderCreateRequest(products: $products, buyerId: $buyerId, '
        'shopId: $shopId, deliveryOption: $deliveryOption, '
        'deliveryDate: $deliveryDate, instruction: $instruction)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderCreateRequest &&
        listEquals(other.products, products) &&
        other.buyerId == buyerId &&
        other.shopId == shopId &&
        other.deliveryOption == deliveryOption &&
        other.deliveryDate == deliveryDate &&
        other.instruction == instruction;
  }

  @override
  int get hashCode {
    return products.hashCode ^
        buyerId.hashCode ^
        shopId.hashCode ^
        deliveryOption.hashCode ^
        deliveryDate.hashCode ^
        instruction.hashCode;
  }
}

String _deliveryOptionToJson(DeliveryOption deliveryOption) =>
    deliveryOption.value;

DeliveryOption _deliveryOptionFromJson(String? value) {
  return DeliveryOption.values.firstWhere(
    (e) => e.value == value,
    orElse: () => DeliveryOption.pickup,
  );
}
