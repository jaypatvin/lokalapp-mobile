import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'operating_hours.dart';
import 'order.dart';
import 'timestamp_time_object.dart';

enum SubscriptionStatus {
  enabled,
  disabled,
  unsubscribed,
  cancelled,
}

extension SubscriptionPlanExtension on SubscriptionStatus {
  String get value {
    switch (this) {
      case SubscriptionStatus.enabled:
        return 'enabled';
      case SubscriptionStatus.disabled:
        return 'disabled';
      case SubscriptionStatus.unsubscribed:
        return 'unsubscribed';
      case SubscriptionStatus.cancelled:
        return 'cancelled';
    }
  }
}

class OverrideDate {
  final DateTime originalDate;
  final DateTime newDate;
  const OverrideDate({
    required this.originalDate,
    required this.newDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'original_date': DateFormat('yyyy-MM-dd').format(originalDate),
      'new_date': DateFormat('yyyy-MM-dd').format(newDate),
    };
  }

  factory OverrideDate.fromMap(Map<String, dynamic> map) {
    return OverrideDate(
      originalDate: DateFormat('yyyy-MM-dd').parse(map['original_date']),
      newDate: DateFormat('yyyy-MM-dd').parse(map['new_date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory OverrideDate.fromJson(String source) =>
      OverrideDate.fromMap(json.decode(source));

  @override
  String toString() =>
      'OverridenDates(originalDate: $originalDate, ' 'newDate: $newDate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OverrideDate &&
        other.originalDate == originalDate &&
        other.newDate == newDate;
  }

  @override
  int get hashCode => originalDate.hashCode ^ newDate.hashCode;
}

class SubscriptionProductDetails {
  final String name;
  final String image;
  final String description;
  final double price;
  const SubscriptionProductDetails({
    required this.name,
    required this.image,
    required this.description,
    required this.price,
  });

  SubscriptionProductDetails copyWith({
    String? name,
    String? image,
    String? description,
    double? price,
  }) {
    return SubscriptionProductDetails(
      name: name ?? this.name,
      image: image ?? this.image,
      description: description ?? this.description,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'description': description,
      'price': price,
    };
  }

  factory SubscriptionProductDetails.fromMap(Map<String, dynamic> map) {
    return SubscriptionProductDetails(
      name: map['name'],
      image: map['image'],
      description: map['description'],
      price: map['price'] + .0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscriptionProductDetails.fromJson(String source) =>
      SubscriptionProductDetails.fromMap(json.decode(source));

  @override
  String toString() {
    return '_SubscriptionProductDetails(name: $name, image: $image, '
        'description: $description, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubscriptionProductDetails &&
        other.name == name &&
        other.image == image &&
        other.description == description &&
        other.price == price;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        image.hashCode ^
        description.hashCode ^
        price.hashCode;
  }
}

class SubscriptionShopDetails {
  final String name;
  final String image;
  final String description;
  SubscriptionShopDetails({
    required this.name,
    required this.image,
    required this.description,
  });

  SubscriptionShopDetails copyWith({
    String? name,
    String? image,
    String? description,
  }) {
    return SubscriptionShopDetails(
      name: name ?? this.name,
      image: image ?? this.image,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'description': description,
    };
  }

  factory SubscriptionShopDetails.fromMap(Map<String, dynamic> map) {
    return SubscriptionShopDetails(
      name: map['name'],
      image: map['image'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscriptionShopDetails.fromJson(String source) =>
      SubscriptionShopDetails.fromMap(json.decode(source));

  @override
  String toString() =>
      '_SubscriptionShopDetails(name: $name, image: $image, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubscriptionShopDetails &&
        other.name == name &&
        other.image == image &&
        other.description == description;
  }

  @override
  int get hashCode => name.hashCode ^ image.hashCode ^ description.hashCode;
}

class ProductSubscriptionSchedule {
  final List<DateTime> startDates;
  final DateTime? lastDate;
  final int repeatUnit;
  final bool autoReschedule;
  final String repeatType;
  final List<CustomDates> schedule;
  final List<DateTime> customDates;
  final List<DateTime> unavailableDates;
  final List<OverrideDate> overrideDates;

  const ProductSubscriptionSchedule({
    required this.startDates,
    required this.lastDate,
    required this.repeatUnit,
    required this.repeatType,
    required this.schedule,
    required this.customDates,
    required this.unavailableDates,
    required this.autoReschedule,
    required this.overrideDates,
  });

  ProductSubscriptionSchedule copyWith({
    List<DateTime>? startDates,
    DateTime? lastDate,
    int? repeatUnit,
    String? repeatType,
    List<CustomDates>? schedule,
    List<DateTime>? customDates,
    List<DateTime>? unavailableDates,
    bool? autoReschedule,
    List<OverrideDate>? overrideDates,
  }) {
    return ProductSubscriptionSchedule(
      startDates: startDates ?? this.startDates,
      lastDate: lastDate ?? this.lastDate,
      repeatUnit: repeatUnit ?? this.repeatUnit,
      repeatType: repeatType ?? this.repeatType,
      schedule: schedule ?? this.schedule,
      customDates: customDates ?? this.customDates,
      unavailableDates: unavailableDates ?? this.unavailableDates,
      autoReschedule: autoReschedule ?? this.autoReschedule,
      overrideDates: overrideDates ?? this.overrideDates,
    );
  }

  factory ProductSubscriptionSchedule.fromMap(Map<String, dynamic> map) {
    final _customDates = <DateTime>[];
    final _unavailableDates = <DateTime>[];
    final _startDates = <DateTime>[];
    final _overrideDates = <OverrideDate>[];

    if (map['custom_dates'] != null) {
      final List<String> customDates = List<String>.from(map['custom_dates']);

      for (final date in customDates) {
        _customDates.add(DateFormat('yyyy-MM-dd').parse(date));
      }
    }
    if (map['unavailable_dates'] != null) {
      final List<String> unavailableDates =
          List<String>.from(map['unavailable_dates']);

      for (final date in unavailableDates) {
        _unavailableDates.add(DateFormat('yyyy-MM-dd').parse(date));
      }
    }

    if (map['override_dates'] != null) {
      final Map<String, String> overrideDates = Map.from(map['override_dates']);
      overrideDates.forEach((key, value) {
        _overrideDates.add(
          OverrideDate(
            originalDate: DateFormat('yyyy-MM-dd').parse(key),
            newDate: DateFormat('yyyy-MM-dd').parse(value),
          ),
        );
      });
    }

    if (map['start_dates'] != null) {
      final startDates = List<String>.from(map['start_dates']);
      for (final date in startDates) {
        _startDates.add(DateFormat('yyyy-MM-dd').parse(date));
      }
    }

    return ProductSubscriptionSchedule(
      startDates: _startDates,
      lastDate: map['last_date'] != null && map['last_date'].isNotEmpty
          ? DateFormat('yyyy-MM-dd').parse(map['last_date'])
          : null,
      repeatUnit: map['repeat_unit'],
      repeatType: map['repeat_type'],
      autoReschedule: map['auto_reschedule'],
      schedule: [],
      customDates: _customDates,
      unavailableDates: _unavailableDates,
      overrideDates: _overrideDates,
    );
  }

  factory ProductSubscriptionSchedule.fromJson(String source) =>
      ProductSubscriptionSchedule.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductSubscriptionSchedule(startDates: $startDates, '
        'lastDate: $lastDate, repeatUnit: $repeatUnit, repeatType: $repeatType, '
        'autoReschedule: $autoReschedule, schedule: $schedule, '
        'overrideDates: $overrideDates)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductSubscriptionSchedule &&
        listEquals(other.startDates, startDates) &&
        other.lastDate == lastDate &&
        other.repeatUnit == repeatUnit &&
        other.repeatType == repeatType &&
        other.autoReschedule == autoReschedule &&
        listEquals(other.schedule, schedule) &&
        listEquals(other.overrideDates, overrideDates);
  }

  @override
  int get hashCode {
    return startDates.hashCode ^
        lastDate.hashCode ^
        repeatUnit.hashCode ^
        repeatType.hashCode ^
        schedule.hashCode ^
        autoReschedule.hashCode ^
        overrideDates.hashCode;
  }
}

class ProductSubscriptionPlan {
  final String id;
  final String productId;
  final String shopId;
  final String buyerId;
  final String sellerId;
  final int quantity;
  final String instruction;
  final SubscriptionStatus status;
  final SubscriptionProductDetails product;
  final ProductSubscriptionSchedule plan;
  final SubscriptionShopDetails shop;
  final DateTime createdAt;

  ProductSubscriptionPlan({
    required this.id,
    required this.productId,
    required this.shopId,
    required this.buyerId,
    required this.sellerId,
    required this.quantity,
    required this.instruction,
    required this.status,
    required this.plan,
    required this.product,
    required this.shop,
    required this.createdAt,
  });

  ProductSubscriptionPlan copyWith({
    String? id,
    String? productId,
    String? shopId,
    String? buyerId,
    String? sellerId,
    int? quantity,
    String? instruction,
    SubscriptionStatus? status,
    ProductSubscriptionSchedule? plan,
    SubscriptionShopDetails? shop,
    OrderProduct? product,
    DateTime? createdAt,
  }) {
    return ProductSubscriptionPlan(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      shopId: shopId ?? this.shopId,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      quantity: quantity ?? this.quantity,
      instruction: instruction ?? this.instruction,
      status: status ?? this.status,
      plan: plan ?? this.plan,
      product: product as SubscriptionProductDetails? ?? this.product,
      shop: shop ?? this.shop,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ProductSubscriptionPlan.fromMap(Map<String, dynamic> map) {
    final _createdAt = (map['created_at'] is Timestamp)
        ? (map['created_at'] as Timestamp).toDate()
        : TimestampObject.fromMap(map['created_at']).toDateTime();
    return ProductSubscriptionPlan(
      id: map['id'],
      productId: map['product_id'],
      shopId: map['shop_id'],
      buyerId: map['buyer_id'],
      sellerId: map['seller_id'],
      quantity: map['quantity'],
      instruction: map['instruction'],
      status: SubscriptionStatus.values.firstWhereOrNull(
            (e) => e.value == map['status'],
          ) ??
          SubscriptionStatus.disabled,
      plan: ProductSubscriptionSchedule.fromMap(map['plan']),
      product: SubscriptionProductDetails.fromMap(map['product']),
      shop: SubscriptionShopDetails.fromMap(map['shop']),
      createdAt: _createdAt,
    );
  }

  factory ProductSubscriptionPlan.fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    return ProductSubscriptionPlan.fromMap({
      ...document.data(),
      'id': document.id,
    });
  }

  factory ProductSubscriptionPlan.fromJson(String source) =>
      ProductSubscriptionPlan.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductSubscriptionPlan(productId: $productId, shopId: $shopId, '
        'buyerId: $buyerId, sellerId: $sellerId, quantity: $quantity, '
        'instruction: $instruction, status: $status, plan: $plan, '
        'product: $product, shop: $shop, id: $id, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductSubscriptionPlan &&
        other.productId == productId &&
        other.shopId == shopId &&
        other.buyerId == buyerId &&
        other.sellerId == sellerId &&
        other.quantity == quantity &&
        other.instruction == instruction &&
        other.status == status &&
        other.plan == plan &&
        other.product == product &&
        other.shop == shop &&
        other.id == id &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        shopId.hashCode ^
        buyerId.hashCode ^
        sellerId.hashCode ^
        quantity.hashCode ^
        instruction.hashCode ^
        status.hashCode ^
        plan.hashCode ^
        product.hashCode ^
        shop.hashCode ^
        id.hashCode ^
        createdAt.hashCode;
  }
}
