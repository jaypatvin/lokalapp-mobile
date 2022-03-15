import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../product_subscription_plan.dart';

part 'override_dates.request.g.dart';

@JsonSerializable()
class OverrideDatesRequest {
  const OverrideDatesRequest(
    this.overrideDates,
  );

  @JsonKey(fromJson: _overrideDatesFromJson)
  final List<OverrideDate> overrideDates;

  OverrideDatesRequest copyWith({
    List<OverrideDate>? overrideDates,
  }) {
    return OverrideDatesRequest(
      overrideDates ?? this.overrideDates,
    );
  }

  Map<String, dynamic> toJson() => _$OverrideDatesRequestToJson(this);
  factory OverrideDatesRequest.fromJson(Map<String, dynamic> json) =>
      _$OverrideDatesRequestFromJson(json);

  @override
  String toString() => 'OverrideDatesRequest(overrideDates: $overrideDates)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OverrideDatesRequest &&
        listEquals(other.overrideDates, overrideDates);
  }

  @override
  int get hashCode => overrideDates.hashCode;
}

List<OverrideDate> _overrideDatesFromJson(Map<String, dynamic> overrideDates) {
  final _format = DateFormat('yyyy-MM-dd');
  return overrideDates.entries
      .map<OverrideDate>(
        (entry) => OverrideDate(
          originalDate: _format.parse(entry.key),
          newDate: _format.parse(entry.value),
        ),
      )
      .toList();
}
