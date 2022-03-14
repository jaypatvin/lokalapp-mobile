import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../payment_option.dart';
import '../../shop.dart';

part 'shop_update.request.g.dart';

@JsonSerializable()
class ShopUpdateRequest {
  const ShopUpdateRequest({
    this.name,
    this.description,
    this.isClose,
    this.status,
    this.deliveryOptions,
    this.paymentOptions,
    this.profilePhoto,
    this.coverPhoto,
  });

  final String? name;
  final String? description;
  final bool? isClose;
  final ShopStatus? status;
  final DeliveryOptions? deliveryOptions;
  final List<PaymentOption>? paymentOptions;
  final String? profilePhoto;
  final String? coverPhoto;

  ShopUpdateRequest copyWith({
    String? name,
    String? description,
    bool? isClose,
    ShopStatus? status,
    DeliveryOptions? deliveryOptions,
    List<PaymentOption>? paymentOptions,
    String? profilePhoto,
    String? coverPhoto,
  }) {
    return ShopUpdateRequest(
      name: name ?? this.name,
      description: description ?? this.description,
      isClose: isClose ?? this.isClose,
      status: status ?? this.status,
      deliveryOptions: deliveryOptions ?? this.deliveryOptions,
      paymentOptions: paymentOptions ?? this.paymentOptions,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      coverPhoto: coverPhoto ?? this.coverPhoto,
    );
  }

  Map<String, dynamic> toJson() => _$ShopUpdateRequestToJson(this);
  factory ShopUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ShopUpdateRequestFromJson(json);

  @override
  String toString() {
    return 'ShopUpdateRequest(name: $name, description: $description, '
        'isClose: $isClose, status: $status, deliveryOptions: $deliveryOptions, '
        'paymentOptions: $paymentOptions, profilePhoto: $profilePhoto, '
        'coverPhoto: $coverPhoto)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShopUpdateRequest &&
        other.name == name &&
        other.description == description &&
        other.isClose == isClose &&
        other.status == status &&
        other.deliveryOptions == deliveryOptions &&
        listEquals(other.paymentOptions, paymentOptions) &&
        other.profilePhoto == profilePhoto &&
        other.coverPhoto == coverPhoto;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        description.hashCode ^
        isClose.hashCode ^
        status.hashCode ^
        deliveryOptions.hashCode ^
        paymentOptions.hashCode ^
        profilePhoto.hashCode ^
        coverPhoto.hashCode;
  }
}
