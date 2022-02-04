import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'operating_hours.dart';
import 'payment_option.dart';
import 'timestamp_time_object.dart';

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

  Map<String, dynamic> toMap() {
    return {
      'delivery': delivery,
      'pickup': pickup,
    };
  }

  factory DeliveryOptions.fromMap(Map<String, dynamic> map) {
    return DeliveryOptions(
      delivery: map['delivery'] ?? false,
      pickup: map['pickup'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryOptions.fromJson(String source) =>
      DeliveryOptions.fromMap(json.decode(source));

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

class Shop {
  final String id;
  final bool archived;
  final String communityId;
  final String? coverPhoto;
  final DateTime createdAt;
  final String description;
  final bool isClosed;
  final String name;
  final OperatingHours operatingHours;
  final List<PaymentOption>? paymentOptions;
  final DeliveryOptions deliveryOptions;
  final String? profilePhoto;
  final ShopStatus status;
  final String userId;
  const Shop({
    required this.id,
    required this.archived,
    required this.communityId,
    required this.coverPhoto,
    required this.createdAt,
    required this.description,
    required this.isClosed,
    required this.name,
    required this.operatingHours,
    required this.paymentOptions,
    required this.deliveryOptions,
    required this.profilePhoto,
    required this.status,
    required this.userId,
  });

  String toJson() => json.encode(toMap());

  factory Shop.fromJson(String source) => Shop.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Shop(id: $id, archived: $archived, communityId: $communityId, '
        'coverPhoto: $coverPhoto, createdAt: $createdAt, '
        'description: $description, isClosed: $isClosed, name: $name, '
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
        other.isClosed == isClosed &&
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
        isClosed.hashCode ^
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
    bool? isClosed,
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
      isClosed: isClosed ?? this.isClosed,
      name: name ?? this.name,
      operatingHours: operatingHours ?? this.operatingHours,
      paymentOptions: paymentOptions ?? this.paymentOptions,
      deliveryOptions: deliveryOptions ?? this.deliveryOptions,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      status: status ?? this.status,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'archived': archived,
      'community_id': communityId,
      'cover_photo': coverPhoto,
      'created_at': createdAt.millisecondsSinceEpoch,
      'description': description,
      'is_close': isClosed,
      'name': name,
      'operating_hours': operatingHours.toMap(),
      'payment_options': paymentOptions?.map((x) => x.toMap()).toList(),
      'delivery_options': deliveryOptions.toMap(),
      'profile_photo': profilePhoto,
      'status': status.value,
      'user_id': userId,
    };
  }

  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      id: map['id'] ?? '',
      archived: map['archived'] ?? false,
      communityId: map['community_id'] ?? '',
      coverPhoto: map['cover_photo'],
      createdAt: TimestampObject.fromMap(map['created_at']).toDateTime(),
      description: map['description'] ?? '',
      isClosed: map['is_close'] ?? false,
      name: map['name'] ?? '',
      operatingHours: OperatingHours.fromMap(map['operating_hours']),
      paymentOptions: List<PaymentOption>.from(
        map['payment_options']?.map(
              (x) => PaymentOption.fromMap(x),
            ) ??
            [],
      ),
      deliveryOptions: map['delivery_options'] != null
          ? DeliveryOptions.fromMap(map['delivery_options'])
          : const DeliveryOptions(),
      profilePhoto: map['profile_photo'],
      status: ShopStatus.values.firstWhere(
        (e) => e.value == map['status'],
        orElse: () => ShopStatus.enabled,
      ),
      userId: map['user_id'] ?? '',
    );
  }
}
