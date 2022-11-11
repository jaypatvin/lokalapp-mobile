import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/json_converters/date_time_converter.dart';
import '../services/json_converters/payment_method_converter.dart';
import '../services/json_converters/subscription_plan_converter.dart';
import '../services/json_converters/subscription_status_converter.dart';
import 'order.dart';

part 'product_subscription_plan.freezed.dart';
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

@freezed
class OverrideDate with _$OverrideDate {
  const factory OverrideDate({
    @DateTimeConverter() required DateTime originalDate,
    @DateTimeConverter() required DateTime newDate,
  }) = _OverrideDate;

  factory OverrideDate.fromJson(Map<String, dynamic> json) =>
      _$OverrideDateFromJson(json);
}

@freezed
class SubscriptionProductDetails with _$SubscriptionProductDetails {
  const factory SubscriptionProductDetails({
    required String name,
    required String image,
    required String description,
    required double price,
  }) = _SubscriptionProductDetails;

  factory SubscriptionProductDetails.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionProductDetailsFromJson(json);
}

@freezed
class SubscriptionShopDetails with _$SubscriptionShopDetails {
  const factory SubscriptionShopDetails({
    required String name,
    required String image,
    required String description,
  }) = _SubscriptionShopDetails;

  factory SubscriptionShopDetails.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionShopDetailsFromJson(json);
}

@freezed
class ProductSubscriptionSchedule with _$ProductSubscriptionSchedule {
  const factory ProductSubscriptionSchedule({
    required bool autoReschedule,
    required String repeatType,
    required int repeatUnit,
    @SubscriptionStartDatesConverter() required List<DateTime> startDates,
    @DateTimeOrNullConverter() DateTime? lastDate,
    @Default({}) Map<String, dynamic> schedule,
    @SubscriptionOverrideDatesConverter()
    @Default([])
        List<OverrideDate> overrideDates,
  }) = _ProductSubscriptionSchedule;

  factory ProductSubscriptionSchedule.fromJson(Map<String, dynamic> json) =>
      _$ProductSubscriptionScheduleFromJson(json);
}

@freezed
class ProductSubscriptionPlan with _$ProductSubscriptionPlan {
  const factory ProductSubscriptionPlan({
    required String id,
    required bool archived,
    required String buyerId,
    required String communityId,
    @DateTimeConverter() required DateTime createdAt,
    required String instruction,
    @PaymentMethodConverter() required PaymentMethod paymentMethod,
    required ProductSubscriptionSchedule plan,
    required SubscriptionProductDetails product,
    required String productId,
    required int quantity,
    required String sellerId,
    required SubscriptionShopDetails shop,
    required String shopId,
    @SubscriptionStatusConverter() required SubscriptionStatus status,
    @DateTimeOrNullConverter() DateTime? updatedAt,
  }) = _ProductSubscriptionPlan;

  factory ProductSubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      _$ProductSubscriptionPlanFromJson(json);

  factory ProductSubscriptionPlan.fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = ProductSubscriptionPlan.fromJson({
      ...document.data(),
      'id': document.id,
    });

    return data;
  }
}
