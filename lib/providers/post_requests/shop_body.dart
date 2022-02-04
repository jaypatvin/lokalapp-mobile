import 'package:flutter/foundation.dart';

import '../../models/payment_option.dart';
import '../../models/shop.dart';
import 'operating_hours_body.dart';

class ShopRequestBody {
  final String userId;
  final String name;
  final String description;
  final bool isClosed;
  final ShopStatus status;
  final String? profilePhoto;
  final String? coverPhoto;
  final OperatingHoursRequestBody operatingHoursBody;
  final List<PaymentOption> paymentOptions;
  final DeliveryOptions deliveryOptions;

  const ShopRequestBody({
    this.userId = '',
    this.name = '',
    this.description = '',
    this.isClosed = false,
    this.status = ShopStatus.enabled,
    this.profilePhoto,
    this.coverPhoto,
    this.operatingHoursBody = const OperatingHoursRequestBody(),
    this.paymentOptions = const [],
    this.deliveryOptions = const DeliveryOptions(),
  });

  ShopRequestBody copyWith({
    String? userId,
    String? name,
    String? description,
    bool? isClosed,
    ShopStatus? status,
    String? profilePhoto,
    String? coverPhoto,
    OperatingHoursRequestBody? operatingHoursBody,
    List<PaymentOption>? paymentOptions,
    DeliveryOptions? deliveryOptions,
  }) {
    return ShopRequestBody(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      isClosed: isClosed ?? this.isClosed,
      status: status ?? this.status,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      operatingHoursBody: operatingHoursBody ?? this.operatingHoursBody,
      paymentOptions: paymentOptions ?? this.paymentOptions,
      deliveryOptions: deliveryOptions ?? this.deliveryOptions,
    );
  }

  Map<String, dynamic> toMap() {
    assert(userId.isNotEmpty, 'userId should not be empty');
    assert(name.isNotEmpty, 'name should not be empty');
    assert(description.isNotEmpty, 'description should not be empty');
    return {
      'user_id': userId,
      'name': name,
      'description': description,
      'is_close': isClosed,
      'status': status.value,
      'profile_photo': profilePhoto,
      'cover_photo': coverPhoto,
      'operating_hours': operatingHoursBody.toMap(),
      'payment_options': paymentOptions.map((x) => x.toMap()).toList(),
      'delivery_options': deliveryOptions.toMap(),
    };
  }

  @override
  String toString() {
    return 'ShopRequestBody(userId: $userId, name: $name, '
        'description: $description, isClosed: $isClosed, status: $status, '
        'profilePhoto: $profilePhoto, coverPhoto: $coverPhoto, '
        'operatingHoursBody: $operatingHoursBody, '
        'paymentOptions: $paymentOptions, deliveryOptions: $deliveryOptions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShopRequestBody &&
        other.userId == userId &&
        other.name == name &&
        other.description == description &&
        other.isClosed == isClosed &&
        other.status == status &&
        other.profilePhoto == profilePhoto &&
        other.coverPhoto == coverPhoto &&
        other.operatingHoursBody == operatingHoursBody &&
        listEquals(other.paymentOptions, paymentOptions) &&
        other.deliveryOptions == deliveryOptions;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        name.hashCode ^
        description.hashCode ^
        isClosed.hashCode ^
        status.hashCode ^
        profilePhoto.hashCode ^
        coverPhoto.hashCode ^
        operatingHoursBody.hashCode ^
        paymentOptions.hashCode ^
        deliveryOptions.hashCode;
  }
}

class ShopBody extends ChangeNotifier {
  ShopRequestBody _body = const ShopRequestBody();
  ShopRequestBody get body => _body;

  Map<String, dynamic> get data => _body.toMap();

  String get name => _body.name;
  String get description => _body.description;
  String? get profilePhoto => _body.profilePhoto;
  String? get coverPhoto => _body.coverPhoto;
  bool get isClose => _body.isClosed;
  ShopStatus get status => _body.status;
  String get userId => _body.userId;
  OperatingHoursRequestBody get operatingHours => _body.operatingHoursBody;
  List<PaymentOption> get paymentOptions => _body.paymentOptions;
  DeliveryOptions get deliveryOptions => _body.deliveryOptions;

  void update({
    String? name,
    String? description,
    String? profilePhoto,
    String? coverPhoto,
    bool? isClose,
    ShopStatus? status,
    String? userId,
    OperatingHoursRequestBody? operatingHours,
    List<PaymentOption>? paymentOptions,
    DeliveryOptions? deliveryOptions,
    bool notify = true,
  }) {
    _body = _body.copyWith(
      userId: userId,
      name: name,
      description: description,
      isClosed: isClose,
      status: status,
      profilePhoto: profilePhoto,
      coverPhoto: coverPhoto,
      operatingHoursBody: operatingHours,
      paymentOptions: paymentOptions,
      deliveryOptions: deliveryOptions,
    );
    if (notify) notifyListeners();
  }

  void clear({bool notify = true}) {
    _body = const ShopRequestBody();
    if (notify) notifyListeners();
  }
}
