import 'dart:convert';

import 'package:flutter/foundation.dart';

class CustomDates {
  String? date;
  String? endTime;
  String? startTime;
  CustomDates({
    this.date,
    this.endTime,
    this.startTime,
  });

  CustomDates copyWith({
    String? date,
    String? endTime,
    String? startTime,
  }) {
    return CustomDates(
      date: date ?? this.date,
      endTime: endTime ?? this.endTime,
      startTime: startTime ?? this.startTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'end_time': endTime,
      'start_time': startTime,
    };
  }

  factory CustomDates.fromMap(Map<String, dynamic> map) {
    return CustomDates(
      date: map['date'],
      endTime: map['end_time'],
      startTime: map['start_time'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomDates.fromJson(String source) =>
      CustomDates.fromMap(json.decode(source));

  @override
  String toString() =>
      'CustomDates(date: $date, endTime: $endTime, startTime: $startTime)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomDates &&
        other.date == date &&
        other.endTime == endTime &&
        other.startTime == startTime;
  }

  @override
  int get hashCode => date.hashCode ^ endTime.hashCode ^ startTime.hashCode;
}

class OperatingHours {
  String? startTime;
  String? endTime;
  String? repeatType;
  int? repeatUnit;
  List<String>? startDates;
  List<String>? unavailableDates;
  List<CustomDates>? customDates;
  OperatingHours({
    this.startTime,
    this.endTime,
    this.repeatType,
    this.repeatUnit,
    this.startDates,
    this.unavailableDates,
    this.customDates,
  });

  OperatingHours copyWith({
    String? startTime,
    String? endTime,
    String? repeatType,
    int? repeatUnit,
    List<String>? startDates,
    List<String>? unavailableDates,
    List<CustomDates>? customDates,
  }) {
    return OperatingHours(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      repeatType: repeatType ?? this.repeatType,
      repeatUnit: repeatUnit ?? this.repeatUnit,
      startDates: startDates ?? this.startDates,
      unavailableDates: unavailableDates ?? this.unavailableDates,
      customDates: customDates ?? this.customDates,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start_time': startTime,
      'end_time': endTime,
      'repeat_type': repeatType?.toLowerCase(),
      'repeat_unit': repeatUnit,
      'start_dates': startDates,
      'unavailable_dates': unavailableDates,
      'custom_dates': customDates?.map((x) => x.toMap()).toList(),
    };
  }

  factory OperatingHours.fromMap(Map<String, dynamic> map) {
    final _customDates = <CustomDates>[];
    final _unavailableDates = <String>[];

    if (map['schedule'] != null && map['schedule']['custom'] != null) {
      final Map<String, dynamic> schedule = map['schedule']['custom'];
      schedule.forEach((key, value) {
        if (value['unavailable'] != null && value['unavailable']) {
          _unavailableDates.add(key);
        } else {
          _customDates.add(
            CustomDates(
              date: key,
              startTime: value['start_time'],
              endTime: value['end_time'],
            ),
          );
        }
      });
    }

    return OperatingHours(
      startTime: map['start_time'] ?? '',
      endTime: map['end_time'] ?? '',
      repeatType: map['repeat_type'] ?? '',
      repeatUnit: map['repeat_unit'] ?? 0,
      startDates: map['start_dates'] != null
          ? List<String>.from(map['start_dates'])
          : <String>[],
      unavailableDates: _unavailableDates,
      customDates: _customDates,
    );
  }

  String toJson() => json.encode(toMap());

  factory OperatingHours.fromJson(String source) =>
      OperatingHours.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OperatingHours(startTime: $startTime, endTime: $endTime, '
        'repeat: $repeatType, repeatEvery: $repeatUnit, '
        'startDates: $startDates, unavailableDates: $unavailableDates, '
        'customDates: $customDates)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OperatingHours &&
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
