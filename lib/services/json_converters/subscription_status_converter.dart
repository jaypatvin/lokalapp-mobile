import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/product_subscription_plan.dart';

class SubscriptionStatusConverter
    implements JsonConverter<SubscriptionStatus, String> {
  const SubscriptionStatusConverter();

  @override
  SubscriptionStatus fromJson(String status) {
    return SubscriptionStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => SubscriptionStatus.disabled,
    );
  }

  @override
  String toJson(SubscriptionStatus status) => status.value;
}
