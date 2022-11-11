import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/json_converters/date_time_converter.dart';
import '../services/json_converters/shop_status_converter.dart';
import 'operating_hours.dart';
import 'payment_option.dart';

part 'shop.freezed.dart';
part 'shop.g.dart';

enum ShopStatus { enabled, disabled }

extension ShopStatusExtension on ShopStatus {
  String get value {
    switch (this) {
      case ShopStatus.enabled:
        return 'enabled';
      case ShopStatus.disabled:
        return 'disabled';
    }
  }
}

@freezed
class DeliveryOptions with _$DeliveryOptions {
  const factory DeliveryOptions({
    @Default(true) bool delivery,
    @Default(true) bool pickup,
  }) = _DeliveryOptions;

  factory DeliveryOptions.fromJson(Map<String, dynamic> json) =>
      _$DeliveryOptionsFromJson(json);
}

@freezed
class Shop with _$Shop {
  const factory Shop({
    required String id,
    required bool archived,
    required String communityId,
    @DateTimeConverter() required DateTime createdAt,
    required String description,
    required bool isClose,
    required String name,
    required OperatingHours operatingHours,
    required DeliveryOptions deliveryOptions,
    required String userId,
    @ShopStatusConverter() required ShopStatus status,
    List<PaymentOption>? paymentOptions,
    String? profilePhoto,
    String? coverPhoto,
  }) = _Shop;

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);

  factory Shop.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Shop.fromJson({'id': doc.id, ...doc.data()!});
  }
}
