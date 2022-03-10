import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/functions.utils.dart';
import 'operating_hours.dart';
import 'payment_option.dart';

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

@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
  includeIfNull: false,
)
class DeliveryOptions {
  const DeliveryOptions({
    this.delivery = true,
    this.pickup = true,
  });

  final bool delivery;
  final bool pickup;

  DeliveryOptions copyWith({
    bool? delivery,
    bool? pickup,
  }) {
    return DeliveryOptions(
      delivery: delivery ?? this.delivery,
      pickup: pickup ?? this.pickup,
    );
  }

  Map<String, dynamic> toJson() => _$DeliveryOptionsToJson(this);
  factory DeliveryOptions.fromJson(Map<String, dynamic> json) =>
      _$DeliveryOptionsFromJson(json);

  @override
  String toString() => 'DeliveryOptions(delivery: $delivery, pickup: $pickup)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeliveryOptions &&
        other.delivery == delivery &&
        other.pickup == pickup;
  }

  @override
  int get hashCode => delivery.hashCode ^ pickup.hashCode;
}

@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
  includeIfNull: false,
)
class Shop {
  @JsonKey(required: true)
  final String id;
  @JsonKey(required: true)
  final bool archived;
  @JsonKey(required: true)
  final String communityId;
  final String? coverPhoto;
  @JsonKey(
    required: true,
    fromJson: createdAtFromJson,
    toJson: dateTimeToString,
  )
  final DateTime createdAt;
  @JsonKey(required: true)
  final String description;
  @JsonKey(required: true)
  final bool isClose;
  @JsonKey(required: true)
  final String name;
  @JsonKey(required: true)
  final OperatingHours operatingHours;
  final List<PaymentOption>? paymentOptions;
  @JsonKey(required: true)
  final DeliveryOptions deliveryOptions;
  final String? profilePhoto;

  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  final ShopStatus status;
  final String userId;
  const Shop({
    required this.id,
    required this.archived,
    required this.communityId,
    required this.coverPhoto,
    required this.createdAt,
    required this.description,
    required this.isClose,
    required this.name,
    required this.operatingHours,
    required this.paymentOptions,
    required this.deliveryOptions,
    required this.profilePhoto,
    required this.status,
    required this.userId,
  });

  Map<String, dynamic> toJson() => _$ShopToJson(this);
  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);

  @override
  String toString() {
    return 'Shop(id: $id, archived: $archived, communityId: $communityId, '
        'coverPhoto: $coverPhoto, createdAt: $createdAt, '
        'description: $description, isClosed: $isClose, name: $name, '
        'operatingHours: $operatingHours, paymentOptions: $paymentOptions, '
        'deliveryOptions: $deliveryOptions, profilePhoto: $profilePhoto, '
        'status: $status, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Shop &&
        other.id == id &&
        other.archived == archived &&
        other.communityId == communityId &&
        other.coverPhoto == coverPhoto &&
        other.createdAt == createdAt &&
        other.description == description &&
        other.isClose == isClose &&
        other.name == name &&
        other.operatingHours == operatingHours &&
        listEquals(other.paymentOptions, paymentOptions) &&
        other.deliveryOptions == deliveryOptions &&
        other.profilePhoto == profilePhoto &&
        other.status == status &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        archived.hashCode ^
        communityId.hashCode ^
        coverPhoto.hashCode ^
        createdAt.hashCode ^
        description.hashCode ^
        isClose.hashCode ^
        name.hashCode ^
        operatingHours.hashCode ^
        paymentOptions.hashCode ^
        deliveryOptions.hashCode ^
        profilePhoto.hashCode ^
        status.hashCode ^
        userId.hashCode;
  }

  Shop copyWith({
    String? id,
    bool? archived,
    String? communityId,
    String? coverPhoto,
    DateTime? createdAt,
    String? description,
    bool? isClose,
    String? name,
    OperatingHours? operatingHours,
    List<PaymentOption>? paymentOptions,
    DeliveryOptions? deliveryOptions,
    String? profilePhoto,
    ShopStatus? status,
    String? userId,
  }) {
    return Shop(
      id: id ?? this.id,
      archived: archived ?? this.archived,
      communityId: communityId ?? this.communityId,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      isClose: isClose ?? this.isClose,
      name: name ?? this.name,
      operatingHours: operatingHours ?? this.operatingHours,
      paymentOptions: paymentOptions ?? this.paymentOptions,
      deliveryOptions: deliveryOptions ?? this.deliveryOptions,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      status: status ?? this.status,
      userId: userId ?? this.userId,
    );
  }

  factory Shop.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Shop.fromJson({'id': doc.id, ...doc.data()!});
  }
}

ShopStatus _statusFromJson(String json) {
  return ShopStatus.values.firstWhere(
    (e) => e.value == json,
    orElse: () => ShopStatus.enabled,
  );
}

String _statusToJson(ShopStatus status) => status.value;
