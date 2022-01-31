import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'timestamp_time_object.dart';

class DeliveryAddress {
  String? barangay;
  String? city;
  String? country;
  String? state;
  String? street;
  String? subdivision;
  String? zipCode;
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
    return 'DeliveryAddress(barangay: $barangay, city: $city, country: $country, state: $state, street: $street, subdivision: $subdivision, zipCode: $zipCode)';
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

class ProductOrder {
  String? instruction;
  String? description;
  String? id;
  String? name;
  double? price;
  int? quantity;
  ProductOrder({
    required this.instruction,
    required this.description,
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  ProductOrder copyWith({
    String? instruction,
    String? productDescription,
    String? productId,
    String? productName,
    double? productPrice,
    int? quantity,
  }) {
    return ProductOrder(
      instruction: instruction ?? this.instruction,
      description: productDescription ?? description,
      id: productId ?? id,
      name: productName ?? name,
      price: productPrice ?? price,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'instruction': instruction,
      'product_description': description,
      'product_id': id,
      'product_name': name,
      'product_price': price,
      'quantity': quantity,
    };
  }

  factory ProductOrder.fromMap(Map<String, dynamic> map) {
    return ProductOrder(
      instruction: map['instruction'],
      description: map['product_description'],
      id: map['product_id'],
      name: map['product_name'],
      price: map['product_price'] + .0,
      quantity: map['quantity'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductOrder.fromJson(String source) =>
      ProductOrder.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductOrder(instruction: $instruction, '
        'productDescription: $description, productId: $id, productName: $name, '
        'productPrice: $price, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductOrder &&
        other.instruction == instruction &&
        other.description == description &&
        other.id == id &&
        other.name == name &&
        other.price == price &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return instruction.hashCode ^
        description.hashCode ^
        id.hashCode ^
        name.hashCode ^
        price.hashCode ^
        quantity.hashCode;
  }
}

class Order {
  final String? id;
  final String? buyerId;
  final String? communityId;
  final DateTime createdAt;
  final DateTime deliveryDate;
  final String? deliveryOption;
  final String? instruction;
  final String? proofOfPayment;
  final String? paymentMethod;
  final bool? isPaid;
  final List<String> productIds;
  final List<ProductOrder> products;
  final String? sellerId;
  final String? shopDescription;
  final String? shopId;
  final String? shopName;
  final String? shopImage;
  final int? statusCode;
  final DeliveryAddress deliveryAddress;
  Order({
    required this.id,
    required this.communityId,
    required this.buyerId,
    required this.createdAt,
    required this.deliveryDate,
    required this.deliveryOption,
    required this.instruction,
    required this.isPaid,
    required this.productIds,
    required this.products,
    required this.sellerId,
    required this.shopDescription,
    required this.shopId,
    required this.shopName,
    required this.statusCode,
    required this.deliveryAddress,
    required this.shopImage,
    required this.proofOfPayment,
    required this.paymentMethod,
  });

  Order copyWith({
    String? id,
    String? buyerId,
    String? communityId,
    DateTime? createdAt,
    DateTime? deliveryDate,
    String? deliveryOption,
    String? instruction,
    bool? isPaid,
    List<String>? productIds,
    List<ProductOrder>? products,
    String? sellerId,
    String? shopDescription,
    String? shopId,
    String? shopName,
    int? statusCode,
    DeliveryAddress? deliveryAddress,
    String? shopImage,
    String? proofOfPayment,
    String? paymentMethod,
  }) {
    return Order(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      communityId: communityId ?? this.communityId,
      createdAt: createdAt ?? this.createdAt,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      deliveryOption: deliveryOption ?? this.deliveryOption,
      instruction: instruction ?? this.instruction,
      isPaid: isPaid ?? this.isPaid,
      productIds: productIds ?? this.productIds,
      products: products ?? this.products,
      sellerId: sellerId ?? this.sellerId,
      shopDescription: shopDescription ?? this.shopDescription,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      statusCode: statusCode ?? this.statusCode,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      shopImage: shopImage ?? this.shopImage,
      proofOfPayment: proofOfPayment ?? this.proofOfPayment,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buyer_id': buyerId,
      'community_id': communityId,
      'created_at': createdAt.millisecondsSinceEpoch,
      'delivery_date': deliveryDate.millisecondsSinceEpoch,
      'delivery_option': deliveryOption,
      'instruction': instruction,
      'is_paid': isPaid,
      'product_ids': productIds,
      'products': products.map((x) => x.toMap()).toList(),
      'seller_id': sellerId,
      'shop_description': shopDescription,
      'shop_id': shopId,
      'shop_name': shopName,
      'status_code': statusCode,
      'delivery_address': deliveryAddress.toMap(),
      'shop_image': shopImage,
      'proof_of_payment': proofOfPayment,
      'payment_method': paymentMethod,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    late final DateTime _createdAt;
    late final DateTime _deliveryDate;

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

    return Order(
      id: map['id'],
      buyerId: map['buyer_id'],
      communityId: map['community_id'],
      createdAt: _createdAt,
      deliveryDate: _deliveryDate,
      deliveryOption: map['delivery_option'],
      instruction: map['instruction'],
      isPaid: map['is_paid'],
      productIds: List<String>.from(map['product_ids']),
      products: List<ProductOrder>.from(
        map['products']?.map((x) => ProductOrder.fromMap(x)),
      ),
      sellerId: map['seller_id'],
      shopDescription: map['shop_description'],
      shopId: map['shop_id'],
      shopName: map['shop_name'],
      statusCode: map['status_code'],
      deliveryAddress: DeliveryAddress.fromMap(map['delivery_address']),
      shopImage: map['shop_image'],
      proofOfPayment: map['proof_of_payment'],
      paymentMethod: map['payment_method'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Order(id: $id, buyerId: $buyerId, communityId: $communityId, createdAt: $createdAt, deliveryDate: $deliveryDate, deliveryOption: $deliveryOption, instruction: $instruction, proofOfPayment: $proofOfPayment, paymentMethod: $paymentMethod, isPaid: $isPaid, productIds: $productIds, products: $products, sellerId: $sellerId, shopDescription: $shopDescription, shopId: $shopId, shopName: $shopName, shopImage: $shopImage, statusCode: $statusCode, deliveryAddress: $deliveryAddress)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Order &&
        other.id == id &&
        other.buyerId == buyerId &&
        other.communityId == communityId &&
        other.createdAt == createdAt &&
        other.deliveryDate == deliveryDate &&
        other.deliveryOption == deliveryOption &&
        other.instruction == instruction &&
        other.proofOfPayment == proofOfPayment &&
        other.paymentMethod == paymentMethod &&
        other.isPaid == isPaid &&
        listEquals(other.productIds, productIds) &&
        listEquals(other.products, products) &&
        other.sellerId == sellerId &&
        other.shopDescription == shopDescription &&
        other.shopId == shopId &&
        other.shopName == shopName &&
        other.shopImage == shopImage &&
        other.statusCode == statusCode &&
        other.deliveryAddress == deliveryAddress;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        buyerId.hashCode ^
        communityId.hashCode ^
        createdAt.hashCode ^
        deliveryDate.hashCode ^
        deliveryOption.hashCode ^
        instruction.hashCode ^
        proofOfPayment.hashCode ^
        paymentMethod.hashCode ^
        isPaid.hashCode ^
        productIds.hashCode ^
        products.hashCode ^
        sellerId.hashCode ^
        shopDescription.hashCode ^
        shopId.hashCode ^
        shopName.hashCode ^
        shopImage.hashCode ^
        statusCode.hashCode ^
        deliveryAddress.hashCode;
  }
}
