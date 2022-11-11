import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/json_converters/date_time_converter.dart';
import '../services/json_converters/delivery_option_converter.dart';
import '../services/json_converters/payment_method_converter.dart';
import 'product_review.dart';

part 'order.freezed.dart';
part 'order.g.dart';

enum DeliveryOption { delivery, pickup }

enum PaymentMethod { bank, cod, eWallet }

extension DeliveryOptionExtension on DeliveryOption {
  String get value {
    switch (this) {
      case DeliveryOption.delivery:
        return 'delivery';
      case DeliveryOption.pickup:
        return 'pickup';
    }
  }
}

extension PaymentMethodExtension on PaymentMethod {
  String get value {
    switch (this) {
      case PaymentMethod.bank:
        return 'bank';
      case PaymentMethod.cod:
        return 'cod';
      case PaymentMethod.eWallet:
        return 'e-wallet';
    }
  }
}

@freezed
class DeliveryAddress with _$DeliveryAddress {
  const factory DeliveryAddress({
    required String barangay,
    required String city,
    required String country,
    required String state,
    required String street,
    required String subdivision,
    required String zipCode,
  }) = _DeliveryAddress;

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      _$DeliveryAddressFromJson(json);
}

@freezed
class OrderProduct with _$OrderProduct {
  const factory OrderProduct({
    required String instruction,
    required String description,
    required String id,
    required String name,
    required String image,
    required double price,
    required int quantity,
    String? category,
    ProductReview? review,
    String? reviewId,
  }) = _OrderProduct;

  factory OrderProduct.fromJson(Map<String, dynamic> json) =>
      _$OrderProductFromJson(json);
}

@freezed
class OrderShop with _$OrderShop {
  const factory OrderShop({
    required String name,
    required String description,
    String? image,
  }) = _OrderShop;

  factory OrderShop.fromJson(Map<String, dynamic> json) =>
      _$OrderShopFromJson(json);
}

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required String buyerId,
    required String communityId,
    @DateTimeConverter() required DateTime createdAt,
    required DeliveryAddress deliveryAddress,
    @DateTimeConverter() required DateTime deliveryDate,
    @DeliveryOptionConverter() required DeliveryOption deliveryOption,
    required String instruction,
    required bool isPaid,
    required List<String> productIds,
    required List<OrderProduct> products,
    required String sellerId,
    required String shopId,
    required OrderShop shop,
    required int statusCode,
    @DateTimeOrNullConverter() DateTime? deliveredDate,
    String? cancellationReason,
    String? declineReason,
    String? productSubscriptionId,
    String? productSubscriptionDate,
    String? proofOfPayment,
    @PaymentMethodOrNullConverter() PaymentMethod? paymentMethod,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
