import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/functions.utils.dart';
import 'order.dart';

part 'product_subscription_plan.g.dart';

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

  int compareTo(SubscriptionStatus other) => index.compareTo(other.index);
}

@JsonSerializable()
class OverrideDate {
  const OverrideDate({
    required this.originalDate,
    required this.newDate,
  });
  @JsonKey(
    required: true,
    fromJson: dateTimeFromJson,
    toJson: nullableDateTimeToString,
  )
  final DateTime originalDate;
  @JsonKey(
    required: true,
    fromJson: dateTimeFromJson,
    toJson: nullableDateTimeToString,
  )
  final DateTime newDate;

  Map<String, dynamic> toJson() => _$OverrideDateToJson(this);

  factory OverrideDate.fromJson(Map<String, dynamic> json) =>
      _$OverrideDateFromJson(json);

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

@JsonSerializable()
class SubscriptionProductDetails {
  const SubscriptionProductDetails({
    required this.name,
    required this.image,
    required this.description,
    required this.price,
  });

  @JsonKey(required: true)
  final String name;
  @JsonKey(required: true)
  final String image;
  @JsonKey(required: true)
  final String description;
  @JsonKey(required: true)
  final double price;

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

  Map<String, dynamic> toJson() => _$SubscriptionProductDetailsToJson(this);

  factory SubscriptionProductDetails.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionProductDetailsFromJson(json);

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

@JsonSerializable()
class SubscriptionShopDetails {
  SubscriptionShopDetails({
    required this.name,
    required this.image,
    required this.description,
  });

  @JsonKey(required: true)
  final String name;
  @JsonKey(required: true)
  final String image;
  @JsonKey(required: true)
  final String description;

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

  Map<String, dynamic> toJson() => _$SubscriptionShopDetailsToJson(this);

  factory SubscriptionShopDetails.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionShopDetailsFromJson(json);

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

@JsonSerializable()
class ProductSubscriptionSchedule {
  const ProductSubscriptionSchedule({
    required this.startDates,
    required this.repeatUnit,
    required this.repeatType,
    required this.autoReschedule,
    this.schedule = const {},
    this.overrideDates = const [],
    this.lastDate,
  });

  @JsonKey(required: true)
  final bool autoReschedule;
  @JsonKey(
    fromJson: nullableDateTimeFromJson,
    toJson: nullableDateTimeToString,
  )
  final DateTime? lastDate;
  @JsonKey(required: true)
  final String repeatType;
  @JsonKey(required: true)
  final int repeatUnit;
  @JsonKey(
    required: true,
    fromJson: _startDatesFromJson,
    toJson: _startDatesToJson,
  )
  final List<DateTime> startDates;
  @JsonKey(fromJson: _overrideDatesFromJson)
  final List<OverrideDate> overrideDates;
  final Map<String, dynamic> schedule;

  ProductSubscriptionSchedule copyWith({
    List<DateTime>? startDates,
    DateTime? lastDate,
    int? repeatUnit,
    String? repeatType,
    Map<String, dynamic>? schedule,
    bool? autoReschedule,
    List<OverrideDate>? overrideDates,
  }) {
    return ProductSubscriptionSchedule(
      startDates: startDates ?? this.startDates,
      lastDate: lastDate ?? this.lastDate,
      repeatUnit: repeatUnit ?? this.repeatUnit,
      repeatType: repeatType ?? this.repeatType,
      schedule: schedule ?? this.schedule,
      autoReschedule: autoReschedule ?? this.autoReschedule,
      overrideDates: overrideDates ?? this.overrideDates,
    );
  }

  Map<String, dynamic> toJson() => _$ProductSubscriptionScheduleToJson(this);

  factory ProductSubscriptionSchedule.fromJson(Map<String, dynamic> json) =>
      _$ProductSubscriptionScheduleFromJson(json);

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
        mapEquals(other.schedule, schedule) &&
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

@JsonSerializable()
class ProductSubscriptionPlan {
  ProductSubscriptionPlan({
    required this.id,
    required this.archived,
    required this.buyerId,
    required this.communityId,
    required this.createdAt,
    required this.instruction,
    required this.paymentMethod,
    required this.plan,
    required this.product,
    required this.productId,
    required this.quantity,
    required this.sellerId,
    required this.shop,
    required this.shopId,
    required this.status,
  });

  @JsonKey(required: true)
  final String id;
  @JsonKey(required: true)
  final bool archived;
  @JsonKey(required: true)
  final String buyerId;
  @JsonKey(required: true)
  final String communityId;
  @JsonKey(
    required: true,
    fromJson: dateTimeFromJson,
    toJson: nullableDateTimeToString,
  )
  final DateTime createdAt;
  @JsonKey(required: true)
  final String instruction;
  @JsonKey(
    required: true,
    fromJson: paymentMethodFromJson,
    toJson: paymentMethodToJson,
  )
  final PaymentMethod paymentMethod;
  @JsonKey(required: true)
  final ProductSubscriptionSchedule plan;
  @JsonKey(required: true)
  final SubscriptionProductDetails product;
  @JsonKey(required: true)
  final String productId;
  @JsonKey(required: true)
  final int quantity;
  @JsonKey(required: true)
  final String sellerId;
  @JsonKey(required: true)
  final SubscriptionShopDetails shop;
  @JsonKey(required: true)
  final String shopId;
  @JsonKey(
    required: true,
    fromJson: _subscriptionStatusFromJson,
    toJson: _subscriptionStatusToJson,
  )
  final SubscriptionStatus status;
  @JsonKey(
    fromJson: nullableDateTimeFromJson,
    toJson: nullableDateTimeToString,
  )
  DateTime? updatedAt;

  ProductSubscriptionPlan copyWith({
    String? id,
    bool? archived,
    String? buyerId,
    String? communityId,
    DateTime? createdAt,
    String? instruction,
    PaymentMethod? paymentMethod,
    ProductSubscriptionSchedule? plan,
    SubscriptionProductDetails? product,
    String? productId,
    int? quantity,
    String? sellerId,
    SubscriptionShopDetails? shop,
    String? shopId,
    SubscriptionStatus? status,
  }) {
    return ProductSubscriptionPlan(
      id: id ?? this.id,
      archived: archived ?? this.archived,
      buyerId: buyerId ?? this.buyerId,
      communityId: communityId ?? this.communityId,
      createdAt: createdAt ?? this.createdAt,
      instruction: instruction ?? this.instruction,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      plan: plan ?? this.plan,
      product: product ?? this.product,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      sellerId: sellerId ?? this.sellerId,
      shop: shop ?? this.shop,
      shopId: shopId ?? this.shopId,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => _$ProductSubscriptionPlanToJson(this);

  factory ProductSubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      _$ProductSubscriptionPlanFromJson(json);

  factory ProductSubscriptionPlan.fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final _data = ProductSubscriptionPlan.fromJson({
      ...document.data(),
      'id': document.id,
    });

    return _data;
  }

  @override
  String toString() {
    return 'ProductSubscriptionPlan(id: $id, archived: $archived, '
        'buyerId: $buyerId, communityId: $communityId, createdAt: $createdAt, '
        'instruction: $instruction, paymentMethod: $paymentMethod, plan: $plan, '
        'product: $product, productId: $productId, quantity: $quantity, '
        'sellerId: $sellerId, shop: $shop, shopId: $shopId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductSubscriptionPlan &&
        other.id == id &&
        other.archived == archived &&
        other.buyerId == buyerId &&
        other.communityId == communityId &&
        other.createdAt == createdAt &&
        other.instruction == instruction &&
        other.paymentMethod == paymentMethod &&
        other.plan == plan &&
        other.product == product &&
        other.productId == productId &&
        other.quantity == quantity &&
        other.sellerId == sellerId &&
        other.shop == shop &&
        other.shopId == shopId &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        archived.hashCode ^
        buyerId.hashCode ^
        communityId.hashCode ^
        createdAt.hashCode ^
        instruction.hashCode ^
        paymentMethod.hashCode ^
        plan.hashCode ^
        product.hashCode ^
        productId.hashCode ^
        quantity.hashCode ^
        sellerId.hashCode ^
        shop.hashCode ^
        shopId.hashCode ^
        status.hashCode;
  }
}

SubscriptionStatus _subscriptionStatusFromJson(String status) {
  return SubscriptionStatus.values.firstWhere(
    (e) => e.value == status,
    orElse: () => SubscriptionStatus.disabled,
  );
}

String _subscriptionStatusToJson(SubscriptionStatus status) => status.value;

List<DateTime> _startDatesFromJson(List<dynamic>? startDates) {
  return startDates
          ?.map<DateTime>((date) => DateFormat('yyyy-MM-dd').parse(date))
          .toList() ??
      const [];
}

List<OverrideDate> _overrideDatesFromJson(Map<String, dynamic> overrideDates) {
  final _format = DateFormat('yyyy-MM-dd');
  return overrideDates.entries
      .map<OverrideDate>(
        (entry) => OverrideDate(
          originalDate: _format.parse(entry.key),
          newDate: _format.parse(entry.value),
        ),
      )
      .toList();
}

List<String> _startDatesToJson(List<DateTime> startDates) {
  return startDates
      .map((date) => DateFormat('yyyy-MM-dd').format(date))
      .toList();
}
