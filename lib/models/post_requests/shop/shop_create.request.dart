import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../payment_option.dart';
import '../../shop.dart';
import 'operating_hours.request.dart';

part 'shop_create.request.g.dart';

@JsonSerializable()
class ShopCreateRequest {
  const ShopCreateRequest({
    this.name = '',
    this.description = '',
    this.userId = '',
    this.isClose = false,
    this.status = ShopStatus.enabled,
    this.deliveryOptions = const DeliveryOptions(),
    this.paymentOptions = const [],
    this.operatingHours = const OperatingHoursRequest(),
    this.profilePhoto,
    this.coverPhoto,
  });

  final String name;
  final String description;
  final String userId;
  final bool isClose;
  final ShopStatus status;
  final DeliveryOptions deliveryOptions;
  final List<PaymentOption> paymentOptions;
  final OperatingHoursRequest operatingHours;
  final String? profilePhoto;
  final String? coverPhoto;

  ShopCreateRequest copyWith({
    String? name,
    String? description,
    String? userId,
    bool? isClose,
    ShopStatus? status,
    DeliveryOptions? deliveryOptions,
    List<PaymentOption>? paymentOptions,
    OperatingHoursRequest? operatingHours,
    String? profilePhoto,
    String? coverPhoto,
  }) {
    return ShopCreateRequest(
      name: name ?? this.name,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      isClose: isClose ?? this.isClose,
      status: status ?? this.status,
      deliveryOptions: deliveryOptions ?? this.deliveryOptions,
      paymentOptions: paymentOptions ?? this.paymentOptions,
      operatingHours: operatingHours ?? this.operatingHours,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      coverPhoto: coverPhoto ?? this.coverPhoto,
    );
  }

  Map<String, dynamic> toJson() => _$ShopCreateRequestToJson(this);

  factory ShopCreateRequest.fromJson(Map<String, dynamic> map) =>
      _$ShopCreateRequestFromJson(map);

  @override
  String toString() {
    return 'ShopCreateRequest(name: $name, description: $description, '
        'userId: $userId, isClose: $isClose, status: $status, '
        'deliveryOptions: $deliveryOptions, paymentOptions: $paymentOptions, '
        'operatingHours: $operatingHours, profilePhoto: $profilePhoto, '
        'coverPhoto: $coverPhoto)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShopCreateRequest &&
        other.name == name &&
        other.description == description &&
        other.userId == userId &&
        other.isClose == isClose &&
        other.status == status &&
        other.deliveryOptions == deliveryOptions &&
        listEquals(other.paymentOptions, paymentOptions) &&
        other.operatingHours == operatingHours &&
        other.profilePhoto == profilePhoto &&
        other.coverPhoto == coverPhoto;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        description.hashCode ^
        userId.hashCode ^
        isClose.hashCode ^
        status.hashCode ^
        deliveryOptions.hashCode ^
        paymentOptions.hashCode ^
        operatingHours.hashCode ^
        profilePhoto.hashCode ^
        coverPhoto.hashCode;
  }
}
