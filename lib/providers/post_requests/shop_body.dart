import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../models/payment_options.dart';
import 'operating_hours_body.dart';

class ShopBody extends ChangeNotifier {
  String? name;
  String? description;
  String? communityId;
  String? profilePhoto;
  String? coverPhoto;
  bool? isClose;
  String? status;
  String? userId;
  OperatingHoursBody? operatingHours;
  PaymentOptions? paymentOptions;
  ShopBody({
    this.name,
    this.description,
    this.communityId,
    this.profilePhoto,
    this.coverPhoto,
    this.isClose = false,
    this.status = 'enabled',
    this.userId,
    this.operatingHours,
    this.paymentOptions,
  });

  void update({
    String? name,
    String? description,
    String? communityId,
    String? profilePhoto,
    String? coverPhoto,
    bool? isClose,
    String? opening,
    String? closing,
    String? status,
    String? userId,
    OperatingHoursBody? operatingHours,
    PaymentOptions? paymentOptions,
    bool notify = true,
  }) {
    this.name = name ?? this.name;
    this.description = description ?? this.description;
    this.communityId = communityId ?? this.communityId;
    this.profilePhoto = profilePhoto ?? this.profilePhoto;
    this.coverPhoto = coverPhoto ?? this.coverPhoto;
    this.isClose = isClose ?? this.isClose;
    this.status = status ?? this.status;
    this.userId = userId ?? this.userId;
    this.operatingHours = operatingHours ?? this.operatingHours;
    this.paymentOptions = paymentOptions ?? this.paymentOptions;
    if (notify) notifyListeners();
  }

  void clear({bool notify = true}) => update(
        name: '',
        description: '',
        communityId: '',
        profilePhoto: '',
        coverPhoto: '',
        isClose: false,
        opening: '',
        closing: '',
        status: 'enabled',
        userId: '',
        operatingHours: OperatingHoursBody(),
        paymentOptions: PaymentOptions(),
        notify: notify,
      );

  ShopBody copyWith({
    String? name,
    String? description,
    String? communityId,
    String? profilePhoto,
    String? coverPhoto,
    bool? isClose,
    String? opening,
    String? closing,
    String? status,
    String? userId,
    OperatingHoursBody? operatingHours,
    PaymentOptions? paymentOptions,
  }) {
    return ShopBody(
      name: name ?? this.name,
      description: description ?? this.description,
      communityId: communityId ?? this.communityId,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      isClose: isClose ?? this.isClose,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      operatingHours: operatingHours ?? this.operatingHours,
      paymentOptions: paymentOptions ?? this.paymentOptions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'community_id': communityId,
      'profile_photo': profilePhoto,
      'cover_photo': coverPhoto,
      'is_close': isClose,
      'status': status,
      'user_id': userId,
      'operating_hours': operatingHours?.toMap(),
      'payment_options': paymentOptions?.toMap(),
    };
  }

  factory ShopBody.fromMap(Map<String, dynamic> map) {
    return ShopBody(
      name: map['name'] != null ? map['name'] : null,
      description: map['description'] != null ? map['description'] : null,
      communityId: map['community_id'] != null ? map['community_id'] : null,
      profilePhoto: map['profile_hoto'] != null ? map['profile_hoto'] : null,
      coverPhoto: map['cover_photo'] != null ? map['cover_photo'] : null,
      isClose: map['is_close'] != null ? map['is_close'] : null,
      status: map['status'] != null ? map['status'] : null,
      userId: map['user_id'] != null ? map['user_id'] : null,
      operatingHours: map['operating_hours'] != null
          ? OperatingHoursBody.fromMap(map['operating_hours'])
          : null,
      paymentOptions: map['payment_options'] != null
          ? PaymentOptions.fromMap(map['payment_options'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShopBody.fromJson(String source) =>
      ShopBody.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ShopBody(name: $name, description: $description, '
        'communityId: $communityId, profilePhoto: $profilePhoto, '
        'coverPhoto: $coverPhoto, isClose: $isClose, '
        'status: $status, userId: $userId, '
        'operatingHours: $operatingHours, paymentOptions: $paymentOptions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShopBody &&
        other.name == name &&
        other.description == description &&
        other.communityId == communityId &&
        other.profilePhoto == profilePhoto &&
        other.coverPhoto == coverPhoto &&
        other.isClose == isClose &&
        other.status == status &&
        other.userId == userId &&
        other.operatingHours == operatingHours &&
        other.paymentOptions == paymentOptions;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        description.hashCode ^
        communityId.hashCode ^
        profilePhoto.hashCode ^
        coverPhoto.hashCode ^
        isClose.hashCode ^
        status.hashCode ^
        userId.hashCode ^
        operatingHours.hashCode ^
        paymentOptions.hashCode;
  }
}
