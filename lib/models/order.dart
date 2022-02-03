import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'timestamp_time_object.dart';

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

class DeliveryAddress {
  String barangay;
  String city;
  String country;
  String state;
  String street;
  String subdivision;
  String zipCode;
  DeliveryAddress({
    required this.barangay,
    required this.city,
    required this.country,
    required this.state,
    required this.street,
    required this.subdivision,
    required this.zipCode,
  });

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

  Map<String, dynamic> toMap() {
    return {
      'barangay': barangay,
      'city': city,
      'country': country,
      'state': state,
      'street': street,
      'subdivision': subdivision,
      'zip_code': zipCode,
    };
  }

  factory DeliveryAddress.fromMap(Map<String, dynamic> map) {
    return DeliveryAddress(
      barangay: map['barangay'],
      city: map['city'],
      country: map['country'],
      state: map['state'],
      street: map['street'],
      subdivision: map['subdivision'],
      zipCode: map['zip_code'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryAddress.fromJson(String source) =>
      DeliveryAddress.fromMap(json.decode(source));

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

class OrderProduct {
  String instruction;
  String description;
  String id;
  String name;
  String image;
  double price;
  int quantity;
  String? category;
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

  Map<String, dynamic> toMap() {
    return {
      'instruction': instruction,
      'description': description,
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'category': category,
    };
  }

  factory OrderProduct.fromMap(Map<String, dynamic> map) {
    return OrderProduct(
      instruction: map['instruction'],
      description: map['description'],
      id: map['id'],
      name: map['name'],
      image: map['image'],
      price: map['price'] + .0,
      quantity: map['quantity'],
      category: map['category'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderProduct.fromJson(String source) =>
      OrderProduct.fromMap(json.decode(source));

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

class OrderShop {
  final String name;
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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'image': image,
    };
  }

  factory OrderShop.fromMap(Map<String, dynamic> map) {
    return OrderShop(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderShop.fromJson(String source) =>
      OrderShop.fromMap(json.decode(source));

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

class Order {
  final String id;
  final String buyerId;
  final String communityId;
  final DateTime createdAt;
  final DeliveryAddress deliveryAddress;
  final DateTime deliveryDate;
  final DateTime? deliveredDate;
  final DeliveryOption deliveryOption;
  final String instruction;
  final bool isPaid;
  final PaymentMethod? paymentMethod;
  final List<String> productIds;
  final List<OrderProduct> products;
  final String? proofOfPayment;
  final String sellerId;
  final String shopId;
  final OrderShop shop;
  final int statusCode;

  final String? cancellationReason;
  final String? declineReason;
  final String? productSubscriptionId;
  final String? productSubscriptionDate;
  const Order({
    // Non-required:
    required this.id,
    required this.buyerId,
    required this.communityId,
    required this.createdAt,
    required this.deliveryAddress,
    required this.deliveryDate,
    required this.deliveredDate,
    required this.deliveryOption,
    required this.instruction,
    required this.isPaid,
    required this.paymentMethod,
    required this.productIds,
    required this.products,
    required this.proofOfPayment,
    required this.sellerId,
    required this.shopId,
    required this.shop,
    required this.statusCode,
    required this.cancellationReason,
    required this.declineReason,
    required this.productSubscriptionId,
    required this.productSubscriptionDate,
  });

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buyer_id': buyerId,
      'community_id': communityId,
      'created_at': createdAt.millisecondsSinceEpoch,
      'delivery_date': deliveryDate.millisecondsSinceEpoch,
      'delivery_option': deliveryOption.value,
      'delivered_date': deliveredDate?.millisecondsSinceEpoch,
      'instruction': instruction,
      'is_paid': isPaid,
      'product_ids': productIds,
      'products': products.map((x) => x.toMap()).toList(),
      'seller_id': sellerId,
      'shop_id': shopId,
      'shop': shop.toMap(),
      'status_code': statusCode,
      'delivery_address': deliveryAddress.toMap(),
      'proof_of_payment': proofOfPayment,
      'payment_method': paymentMethod?.value,
      'cancellation_reason': cancellationReason,
      'decline_reason': declineReason,
      'product_subscription_id': productSubscriptionId,
      'product_subscription_date': productSubscriptionDate,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    late final DateTime _createdAt;
    late final DateTime _deliveryDate;
    late final DateTime? _deliveredDate;

    if (map['created_at'] is Timestamp) {
      _createdAt = (map['created_at'] as Timestamp).toDate();
    } else {
      _createdAt = TimestampObject.fromMap(map['created_at']).toDateTime();
    }

    if (map['delivery_date'] is Timestamp) {
      _deliveryDate = (map['delivery_date'] as Timestamp).toDate();
    } else {
      _deliveryDate = TimestampObject.fromMap(map['created_at']).toDateTime();
    }

    if (map['delivered_date'] == null) {
      _deliveredDate = null;
    } else if (map['delivered_date'] is Timestamp) {
      _deliveredDate = (map['delivered_date'] as Timestamp).toDate();
    } else {
      _deliveredDate =
          TimestampObject.fromMap(map['delivered_date']).toDateTime();
    }

    return Order(
      id: map['id'],
      buyerId: map['buyer_id'],
      communityId: map['community_id'],
      createdAt: _createdAt,
      deliveryDate: _deliveryDate,
      deliveryOption: DeliveryOption.values.firstWhere(
        (e) => e.value == map['delivery_option'],
        orElse: () => DeliveryOption.pickup,
      ),
      instruction: map['instruction'],
      isPaid: map['is_paid'],
      productIds: List<String>.from(map['product_ids']),
      products: List<OrderProduct>.from(
        map['products']?.map((x) => OrderProduct.fromMap(x)),
      ),
      sellerId: map['seller_id'],
      shopId: map['shop_id'],
      shop: OrderShop.fromMap(map['shop']),
      statusCode: int.parse(map['status_code'].toString()),
      deliveryAddress: DeliveryAddress.fromMap(map['delivery_address']),
      proofOfPayment: map['proof_of_payment'],
      paymentMethod: PaymentMethod.values.firstWhereOrNull(
        (e) => e.value == map['payment_method'],
      ),
      deliveredDate: _deliveredDate,
      cancellationReason: map['cancellation_reason'],
      declineReason: map['decline_reason'],
      productSubscriptionId: map['product_subscription_id'],
      productSubscriptionDate: map['product_subscription_date'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));

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
