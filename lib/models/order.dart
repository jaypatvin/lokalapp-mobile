import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/functions.utils.dart';

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

@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
  includeIfNull: false,
)
class DeliveryAddress {
  const DeliveryAddress({
    required this.barangay,
    required this.city,
    required this.country,
    required this.state,
    required this.street,
    required this.subdivision,
    required this.zipCode,
  });

  @JsonKey(required: true)
  final String barangay;
  @JsonKey(required: true)
  final String city;
  @JsonKey(required: true)
  final String country;
  @JsonKey(required: true)
  final String state;
  @JsonKey(required: true)
  final String street;
  @JsonKey(required: true)
  final String subdivision;
  @JsonKey(required: true)
  final String zipCode;

  DeliveryAddress copyWith({
    String? barangay,
    String? city,
    String? country,
    String? state,
    String? street,
    String? subdivision,
    String? zipCode,
  }) {
    return DeliveryAddress(
      barangay: barangay ?? this.barangay,
      city: city ?? this.city,
      country: country ?? this.country,
      state: state ?? this.state,
      street: street ?? this.street,
      subdivision: subdivision ?? this.subdivision,
      zipCode: zipCode ?? this.zipCode,
    );
  }

  Map<String, dynamic> toJson() => _$DeliveryAddressToJson(this);

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      _$DeliveryAddressFromJson(json);

  @override
  String toString() {
    return 'DeliveryAddress(barangay: $barangay, city: $city, '
        'country: $country, state: $state, street: $street, '
        'subdivision: $subdivision, zipCode: $zipCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeliveryAddress &&
        other.barangay == barangay &&
        other.city == city &&
        other.country == country &&
        other.state == state &&
        other.street == street &&
        other.subdivision == subdivision &&
        other.zipCode == zipCode;
  }

  @override
  int get hashCode {
    return barangay.hashCode ^
        city.hashCode ^
        country.hashCode ^
        state.hashCode ^
        street.hashCode ^
        subdivision.hashCode ^
        zipCode.hashCode;
  }
}

@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
  includeIfNull: false,
)
class OrderProduct {
  OrderProduct({
    required this.instruction,
    required this.description,
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    this.category,
  });

  @JsonKey(required: true)
  final String instruction;
  @JsonKey(required: true)
  final String description;
  @JsonKey(required: true)
  final String id;
  @JsonKey(required: true)
  final String name;
  @JsonKey(required: true)
  final String image;
  @JsonKey(required: true)
  final double price;
  @JsonKey(required: true)
  final int quantity;
  final String? category;

  OrderProduct copyWith({
    String? instruction,
    String? description,
    String? id,
    String? name,
    String? image,
    double? price,
    int? quantity,
    String? category,
  }) {
    return OrderProduct(
      instruction: instruction ?? this.instruction,
      description: description ?? this.description,
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() => _$OrderProductToJson(this);

  factory OrderProduct.fromJson(Map<String, dynamic> json) =>
      _$OrderProductFromJson(json);

  @override
  String toString() {
    return 'ProductOrder(instruction: $instruction, '
        'productDescription: $description, productId: $id, productName: $name, '
        'image: $image, productPrice: $price, quantity: $quantity, '
        'category?: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderProduct &&
        other.instruction == instruction &&
        other.description == description &&
        other.id == id &&
        other.name == name &&
        other.image == image &&
        other.price == price &&
        other.quantity == quantity &&
        other.category == category;
  }

  @override
  int get hashCode {
    return instruction.hashCode ^
        description.hashCode ^
        id.hashCode ^
        name.hashCode ^
        image.hashCode ^
        price.hashCode ^
        quantity.hashCode ^
        category.hashCode;
  }
}

@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
  includeIfNull: false,
)
class OrderShop {
  @JsonKey(required: true)
  final String name;
  @JsonKey(required: true)
  final String description;
  final String? image;

  const OrderShop({
    required this.name,
    required this.description,
    this.image,
  });

  OrderShop copyWith({
    String? name,
    String? description,
    String? image,
  }) {
    return OrderShop(
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toJson() => _$OrderShopToJson(this);

  factory OrderShop.fromJson(Map<String, dynamic> json) =>
      _$OrderShopFromJson(json);

  @override
  String toString() =>
      'OrderShop(name: $name, description: $description, image: $image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderShop &&
        other.name == name &&
        other.description == description &&
        other.image == image;
  }

  @override
  int get hashCode => name.hashCode ^ description.hashCode ^ image.hashCode;
}

@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
  includeIfNull: false,
)
class Order {
  const Order({
    required this.id,
    required this.buyerId,
    required this.communityId,
    required this.createdAt,
    required this.deliveryAddress,
    required this.deliveryDate,
    required this.deliveryOption,
    required this.instruction,
    required this.isPaid,
    required this.productIds,
    required this.products,
    required this.sellerId,
    required this.shopId,
    required this.shop,
    required this.statusCode,
    this.deliveredDate,
    this.cancellationReason,
    this.declineReason,
    this.productSubscriptionId,
    this.productSubscriptionDate,
    this.proofOfPayment,
    this.paymentMethod,
  });

  @JsonKey(required: true)
  final String id;
  @JsonKey(required: true)
  final String buyerId;
  @JsonKey(required: true)
  final String communityId;
  @JsonKey(
    required: true,
    fromJson: createdAtFromJson,
    toJson: dateTimeToString,
  )
  final DateTime createdAt;
  @JsonKey(required: true)
  final DeliveryAddress deliveryAddress;
  @JsonKey(
    required: true,
    fromJson: createdAtFromJson,
    toJson: dateTimeToString,
  )
  final DateTime deliveryDate;
  @JsonKey(
    required: true,
    fromJson: _deliveryOptionFromJson,
    toJson: _deliveryOptionToJson,
  )
  final DeliveryOption deliveryOption;
  @JsonKey(required: true)
  final String instruction;
  @JsonKey(required: true)
  final bool isPaid;
  @JsonKey(required: true, defaultValue: [])
  final List<String> productIds;
  @JsonKey(required: true, defaultValue: [])
  final List<OrderProduct> products;
  @JsonKey(required: true)
  final String sellerId;
  @JsonKey(required: true)
  final String shopId;
  @JsonKey(required: true)
  final OrderShop shop;
  @JsonKey(required: true)
  final int statusCode;

  @JsonKey(
    fromJson: nullableDateTimeFromJson,
    toJson: dateTimeToString,
  )
  final DateTime? deliveredDate;
  final String? cancellationReason;
  final String? declineReason;
  final String? productSubscriptionId;
  final String? productSubscriptionDate;
  final String? proofOfPayment;

  @JsonKey(fromJson: _paymentMethodFromJson, toJson: _paymentMethodToJson)
  final PaymentMethod? paymentMethod;

  Order copyWith({
    String? id,
    String? buyerId,
    String? communityId,
    DateTime? createdAt,
    DeliveryAddress? deliveryAddress,
    DateTime? deliveryDate,
    DateTime? deliveredDate,
    DeliveryOption? deliveryOption,
    String? instruction,
    bool? isPaid,
    PaymentMethod? paymentMethod,
    List<String>? productIds,
    List<OrderProduct>? products,
    String? proofOfPayment,
    String? sellerId,
    String? shopId,
    OrderShop? shop,
    int? statusCode,
    String? cancellationReason,
    String? declineReason,
    String? productSubscriptionId,
    String? productSubscriptionDate,
  }) {
    return Order(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      communityId: communityId ?? this.communityId,
      createdAt: createdAt ?? this.createdAt,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      deliveredDate: deliveredDate ?? this.deliveredDate,
      deliveryOption: deliveryOption ?? this.deliveryOption,
      instruction: instruction ?? this.instruction,
      isPaid: isPaid ?? this.isPaid,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      productIds: productIds ?? this.productIds,
      products: products ?? this.products,
      proofOfPayment: proofOfPayment ?? this.proofOfPayment,
      sellerId: sellerId ?? this.sellerId,
      shopId: shopId ?? this.shopId,
      shop: shop ?? this.shop,
      statusCode: statusCode ?? this.statusCode,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      declineReason: declineReason ?? this.declineReason,
      productSubscriptionId:
          productSubscriptionId ?? this.productSubscriptionId,
      productSubscriptionDate:
          productSubscriptionDate ?? this.productSubscriptionDate,
    );
  }

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  @override
  String toString() {
    return 'Order(id: $id, buyerId: $buyerId, communityId: $communityId, '
        'createdAt: $createdAt, deliveryAddress: $deliveryAddress, '
        'deliveryDate: $deliveryDate, deliveredDate: $deliveredDate, '
        'deliveryOption: $deliveryOption, instruction: $instruction, '
        'isPaid: $isPaid, paymentMethod: $paymentMethod, '
        'productIds: $productIds, products: $products, '
        'proofOfPayment: $proofOfPayment, sellerId: $sellerId, '
        'shopId: $shopId, shop: $shop, statusCode: $statusCode, '
        'cancellationReason: $cancellationReason, '
        'declineReason: $declineReason, '
        'productSubscriptionId: $productSubscriptionId, '
        'productSubscriptionDate: $productSubscriptionDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Order &&
        other.id == id &&
        other.buyerId == buyerId &&
        other.communityId == communityId &&
        other.createdAt == createdAt &&
        other.deliveryAddress == deliveryAddress &&
        other.deliveryDate == deliveryDate &&
        other.deliveredDate == deliveredDate &&
        other.deliveryOption == deliveryOption &&
        other.instruction == instruction &&
        other.isPaid == isPaid &&
        other.paymentMethod == paymentMethod &&
        listEquals(other.productIds, productIds) &&
        listEquals(other.products, products) &&
        other.proofOfPayment == proofOfPayment &&
        other.sellerId == sellerId &&
        other.shopId == shopId &&
        other.shop == shop &&
        other.statusCode == statusCode &&
        other.cancellationReason == cancellationReason &&
        other.declineReason == declineReason &&
        other.productSubscriptionId == productSubscriptionId &&
        other.productSubscriptionDate == productSubscriptionDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        buyerId.hashCode ^
        communityId.hashCode ^
        createdAt.hashCode ^
        deliveryAddress.hashCode ^
        deliveryDate.hashCode ^
        deliveredDate.hashCode ^
        deliveryOption.hashCode ^
        instruction.hashCode ^
        isPaid.hashCode ^
        paymentMethod.hashCode ^
        productIds.hashCode ^
        products.hashCode ^
        proofOfPayment.hashCode ^
        sellerId.hashCode ^
        shopId.hashCode ^
        shop.hashCode ^
        statusCode.hashCode ^
        cancellationReason.hashCode ^
        declineReason.hashCode ^
        productSubscriptionId.hashCode ^
        productSubscriptionDate.hashCode;
  }
}

DeliveryOption _deliveryOptionFromJson(String value) {
  return DeliveryOption.values.firstWhere(
    (e) => e.value == value,
    orElse: () => DeliveryOption.pickup,
  );
}

String? _deliveryOptionToJson(DeliveryOption? option) => option?.value;

PaymentMethod? _paymentMethodFromJson(String? value) {
  return PaymentMethod.values.firstWhereOrNull((e) => e.value == value);
}

String? _paymentMethodToJson(PaymentMethod? method) => method?.value;
