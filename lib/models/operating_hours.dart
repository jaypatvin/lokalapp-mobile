// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'operating_hours.freezed.dart';
part 'operating_hours.g.dart';

@freezed
class CustomDates with _$CustomDates {
  const factory CustomDates({
    @JsonKey(readValue: _dateReadValueFrom, fromJson: _dateFromJson)
        required String date,
    required String endTime,
    required String startTime,
  }) = _CustomDates;

  factory CustomDates.fromJson(Map<String, dynamic> json) =>
      _$CustomDatesFromJson(json);
}

String _dateReadValueFrom(Map<dynamic, dynamic> map, String key) {
  return key;
}

String _dateFromJson(String date) => date;

@freezed
class OperatingHours with _$OperatingHours {
  const factory OperatingHours({
    @Default('8:00 AM')
        String startTime,
    @Default('5:00 PM')
        String endTime,
    @Default('day')
        String repeatType,
    @Default(1)
        int repeatUnit,
    @Default(<String>[])
        List<String> startDates,
    @JsonKey(
      readValue: _unavailableDatesReadValue,
      fromJson: _unavailableDatesFromJson,
    )
    @Default(<String>[])
        List<String> unavailableDates,
    @JsonKey(readValue: _customDatesReadValue, fromJson: _customDatesFromJson)
    @Default(<CustomDates>[])
        List<CustomDates> customDates,
  }) = _OperatingHours;

  factory OperatingHours.fromJson(Map<String, dynamic> json) =>
      _$OperatingHoursFromJson(json);
}

List<String>? _unavailableDatesReadValue(
  Map<dynamic, dynamic> map,
  String key,
) {
  final unavailableDates = <String>[];
  if (map['schedule'] != null && map['schedule']['custom'] != null) {
    final Map<String, dynamic> schedule = map['schedule']['custom'];
    schedule.forEach((key, value) {
      if (value['unavailable'] != null && value['unavailable']) {
        unavailableDates.add(key);
      }
    });
  }
  return unavailableDates;
}

List<String> _unavailableDatesFromJson(List<String> value) => value;

List<CustomDates> _customDatesReadValue(Map<dynamic, dynamic> map, String key) {
  final customDates = <CustomDates>[];
  if (map['schedule'] != null && map['schedule']['custom'] != null) {
    final Map<String, dynamic> schedule = map['schedule']['custom'];
    schedule.forEach((key, value) {
      if (!(value['unavailable'] ?? false)) {
        customDates.add(
          CustomDates(
            date: key,
            endTime: value['end_time'],
            startTime: value['start_time'],
          ),
        );
      }
    });
  }
  return customDates;
}

List<CustomDates> _customDatesFromJson(List<CustomDates> value) => value;
