import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../operating_hours.dart';

part 'operating_hours.request.g.dart';

@JsonSerializable()
class OperatingHoursRequest {
  const OperatingHoursRequest({
    this.startTime = '8:00 AM',
    this.endTime = '5:00 PM',
    this.repeatType = 'day',
    this.repeatUnit = 1,
    this.startDates = const [],
    this.unavailableDates = const [],
    this.customDates = const [],
  });

  final String startTime;
  final String endTime;
  final String repeatType;
  final int repeatUnit;
  final List<String> startDates;
  final List<String> unavailableDates;
  final List<CustomDates> customDates;

  OperatingHoursRequest copyWith({
    String? startTime,
    String? endTime,
    String? repeatType,
    int? repeatUnit,
    List<String>? startDates,
    List<String>? unavailableDates,
    List<CustomDates>? customDates,
  }) {
    return OperatingHoursRequest(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      repeatType: repeatType ?? this.repeatType,
      repeatUnit: repeatUnit ?? this.repeatUnit,
      startDates: startDates ?? this.startDates,
      unavailableDates: unavailableDates ?? this.unavailableDates,
      customDates: customDates ?? this.customDates,
    );
  }

  factory OperatingHoursRequest.fromJson(Map<String, dynamic> json) =>
      _$OperatingHoursRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OperatingHoursRequestToJson(this);

  @override
  String toString() {
    return 'OperatingHoursRequestBody(startTime: $startTime, '
        'endTime: $endTime, repeatType: $repeatType, repeatUnit: $repeatUnit, '
        'startDates: $startDates, unavailableDates: $unavailableDates, '
        'customDates: $customDates)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OperatingHoursRequest &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.repeatType == repeatType &&
        other.repeatUnit == repeatUnit &&
        listEquals(other.startDates, startDates) &&
        listEquals(other.unavailableDates, unavailableDates) &&
        listEquals(other.customDates, customDates);
  }

  @override
  int get hashCode {
    return startTime.hashCode ^
        endTime.hashCode ^
        repeatType.hashCode ^
        repeatUnit.hashCode ^
        startDates.hashCode ^
        unavailableDates.hashCode ^
        customDates.hashCode;
  }
}
