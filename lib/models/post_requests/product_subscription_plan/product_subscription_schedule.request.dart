import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_subscription_schedule.request.g.dart';

@JsonSerializable()
class ProductSubscriptionScheduleRequest {
  const ProductSubscriptionScheduleRequest({
    required this.startDates,
    required this.repeatUnit,
    required this.repeatType,
    this.lastDate,
  });

  @JsonKey(fromJson: _startDatesFromJson, toJson: _startDatesToJson)
  final List<DateTime> startDates;
  final int repeatUnit;
  final String repeatType;
  final DateTime? lastDate;

  Map<String, dynamic> toJson() =>
      _$ProductSubscriptionScheduleRequestToJson(this);

  factory ProductSubscriptionScheduleRequest.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ProductSubscriptionScheduleRequestFromJson(json);

  ProductSubscriptionScheduleRequest copyWith({
    List<DateTime>? startDates,
    int? repeatUnit,
    String? repeatType,
    DateTime? lastDate,
  }) {
    return ProductSubscriptionScheduleRequest(
      startDates: startDates ?? this.startDates,
      repeatUnit: repeatUnit ?? this.repeatUnit,
      repeatType: repeatType ?? this.repeatType,
      lastDate: lastDate ?? this.lastDate,
    );
  }

  @override
  String toString() {
    return 'ProductSubscriptionScheduleRequest(startDates: $startDates, '
        'repeatUnit: $repeatUnit, repeatType: $repeatType, lastDate: $lastDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductSubscriptionScheduleRequest &&
        listEquals(other.startDates, startDates) &&
        other.repeatUnit == repeatUnit &&
        other.repeatType == repeatType &&
        other.lastDate == lastDate;
  }

  @override
  int get hashCode {
    return startDates.hashCode ^
        repeatUnit.hashCode ^
        repeatType.hashCode ^
        lastDate.hashCode;
  }
}

List<DateTime> _startDatesFromJson(List<dynamic>? startDates) {
  return startDates
          ?.map<DateTime>((date) => DateFormat('yyyy-MM-dd').parse(date))
          .toList() ??
      const [];
}

List<String> _startDatesToJson(List<DateTime> startDates) {
  return startDates
      .map((date) => DateFormat('yyyy-MM-dd').format(date))
      .toList();
}
