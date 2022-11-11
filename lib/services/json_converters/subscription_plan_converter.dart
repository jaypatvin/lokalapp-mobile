import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../models/product_subscription_plan.dart';

class SubscriptionStartDatesConverter
    implements JsonConverter<List<DateTime>, List<String>> {
  const SubscriptionStartDatesConverter();

  @override
  List<DateTime> fromJson(List<String>? startDates) {
    return startDates
            ?.map<DateTime>((date) => DateFormat('yyyy-MM-dd').parse(date))
            .toList() ??
        const [];
  }

  @override
  List<String> toJson(List<DateTime> startDates) {
    return startDates
        .map((date) => DateFormat('yyyy-MM-dd').format(date))
        .toList();
  }
}

class SubscriptionOverrideDatesConverter
    implements JsonConverter<List<OverrideDate>, Map<String, dynamic>> {
  const SubscriptionOverrideDatesConverter();

  @override
  List<OverrideDate> fromJson(Map<String, dynamic> json) {
    final format = DateFormat('yyyy-MM-dd');
    return json.entries
        .map<OverrideDate>(
          (entry) => OverrideDate(
            originalDate: format.parse(entry.key),
            newDate: format.parse(entry.value),
          ),
        )
        .toList();
  }

  @override
  Map<String, String> toJson(List<OverrideDate> dates) {
    final dateFormat = DateFormat('yyyy-MM-dd');

    final map = <String, String>{};

    for (final date in dates) {
      map[dateFormat.format(date.originalDate)] =
          dateFormat.format(date.newDate);
    }

    return map;
  }
}
