import 'package:flutter/foundation.dart';

import '../../models/payment_option.dart';
import '../../models/post_requests/shop/operating_hours.request.dart';
import '../../models/post_requests/shop/shop_create.request.dart';
import '../../models/shop.dart';

class ShopBody extends ChangeNotifier {
  ShopCreateRequest _body = const ShopCreateRequest();
  ShopCreateRequest get request => _body;

  String get name => _body.name;
  String get description => _body.description;
  String? get profilePhoto => _body.profilePhoto;
  String? get coverPhoto => _body.coverPhoto;
  bool get isClose => _body.isClose;
  ShopStatus get status => _body.status;
  String get userId => _body.userId;
  OperatingHoursRequest get operatingHours => _body.operatingHours;
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
    OperatingHoursRequest? operatingHours,
    List<PaymentOption>? paymentOptions,
    DeliveryOptions? deliveryOptions,
    bool notify = true,
  }) {
    _body = _body.copyWith(
      userId: userId,
      name: name,
      description: description,
      isClose: isClose,
      status: status,
      profilePhoto: profilePhoto,
      coverPhoto: coverPhoto,
      operatingHours: operatingHours,
      paymentOptions: paymentOptions,
      deliveryOptions: deliveryOptions,
    );
    if (notify) notifyListeners();
  }

  void clear({bool notify = true}) {
    _body = const ShopCreateRequest();
    if (notify) notifyListeners();
  }
}
