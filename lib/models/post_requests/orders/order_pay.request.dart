import 'package:json_annotation/json_annotation.dart';

import '../../../utils/functions.utils.dart';
import '../../order.dart';

part 'order_pay.request.g.dart';

@JsonSerializable()
class OrderPayRequest {
  OrderPayRequest({
    this.buyerId,
    required this.paymentMethod,
    this.proofOfPayment,
  }) : assert(
          paymentMethod == PaymentMethod.cod ||
              (paymentMethod != PaymentMethod.cod &&
                  (proofOfPayment?.isNotEmpty ?? false)),
          'A non-COD payment method must contain a proof of payment.',
        );

  final String? buyerId;
  @JsonKey(fromJson: paymentMethodFromJson, toJson: paymentMethodToJson)
  final PaymentMethod paymentMethod;
  final String? proofOfPayment;

  Map<String, dynamic> toJson() => _$OrderPayRequestToJson(this);
  factory OrderPayRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderPayRequestFromJson(json);

  OrderPayRequest copyWith({
    String? buyerId,
    PaymentMethod? paymentMethod,
    String? proofOfPayment,
  }) {
    return OrderPayRequest(
      buyerId: buyerId ?? this.buyerId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      proofOfPayment: proofOfPayment ?? this.proofOfPayment,
    );
  }

  @override
  String toString() =>
      'OrderPayRequest(buyerId: $buyerId, paymentMethod: $paymentMethod, '
      'proofOfPayment: $proofOfPayment)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderPayRequest &&
        other.buyerId == buyerId &&
        other.paymentMethod == paymentMethod &&
        other.proofOfPayment == proofOfPayment;
  }

  @override
  int get hashCode =>
      buyerId.hashCode ^ paymentMethod.hashCode ^ proofOfPayment.hashCode;
}
