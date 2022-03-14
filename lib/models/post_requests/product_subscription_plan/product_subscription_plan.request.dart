import 'package:json_annotation/json_annotation.dart';

import '../../../utils/functions.utils.dart';
import '../../order.dart';
import 'product_subscription_schedule.request.dart';

part 'product_subscription_plan.request.g.dart';

@JsonSerializable()
class ProductSubscriptionPlanRequest {
  const ProductSubscriptionPlanRequest({
    required this.productId,
    required this.shopId,
    this.buyerId,
    required this.quantity,
    this.instruction,
    required this.paymentMethod,
    required this.plan,
  });

  final String productId;
  final String shopId;
  final String? buyerId;
  final int quantity;
  final String? instruction;
  @JsonKey(fromJson: paymentMethodFromJson, toJson: paymentMethodToJson)
  final PaymentMethod paymentMethod;
  final ProductSubscriptionScheduleRequest plan;

  Map<String, dynamic> toJson() => _$ProductSubscriptionPlanRequestToJson(this);
  factory ProductSubscriptionPlanRequest.fromJson(Map<String, dynamic> json) =>
      _$ProductSubscriptionPlanRequestFromJson(json);

  ProductSubscriptionPlanRequest copyWith({
    String? productId,
    String? shopId,
    String? buyerId,
    int? quantity,
    String? instruction,
    PaymentMethod? paymentMethod,
    ProductSubscriptionScheduleRequest? plan,
  }) {
    return ProductSubscriptionPlanRequest(
      productId: productId ?? this.productId,
      shopId: shopId ?? this.shopId,
      buyerId: buyerId ?? this.buyerId,
      quantity: quantity ?? this.quantity,
      instruction: instruction ?? this.instruction,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      plan: plan ?? this.plan,
    );
  }

  @override
  String toString() {
    return 'ProductSubscriptionPlanRequest(productId: $productId, '
        'shopId: $shopId, buyerId: $buyerId, quantity: $quantity, '
        'instruction: $instruction, paymentMethod: $paymentMethod, plan: $plan)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductSubscriptionPlanRequest &&
        other.productId == productId &&
        other.shopId == shopId &&
        other.buyerId == buyerId &&
        other.quantity == quantity &&
        other.instruction == instruction &&
        other.paymentMethod == paymentMethod &&
        other.plan == plan;
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        shopId.hashCode ^
        buyerId.hashCode ^
        quantity.hashCode ^
        instruction.hashCode ^
        paymentMethod.hashCode ^
        plan.hashCode;
  }
}
