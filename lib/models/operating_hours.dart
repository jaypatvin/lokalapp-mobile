import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'operating_hours.g.dart';

@JsonSerializable()
class CustomDates {
  const CustomDates({
    required this.date,
    required this.endTime,
    required this.startTime,
  });
  @JsonKey(readValue: _dateReadValueFrom, fromJson: _dateFromJson)
  final String date;
  final String endTime;
  final String startTime;

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

  Map<String, dynamic> toJson() => _$CustomDatesToJson(this);
  factory CustomDates.fromJson(Map<String, dynamic> json) =>
      _$CustomDatesFromJson(json);

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

String _dateReadValueFrom(Map<dynamic, dynamic> map, String key) {
  return key;
}

String _dateFromJson(String date) => date;

@JsonSerializable()
class OperatingHours {
  const OperatingHours({
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
  @JsonKey(
    readValue: _unavailableDatesReadValue,
    fromJson: _unavailableDatesFromJson,
  )
  final List<String> unavailableDates;
  @JsonKey(readValue: _customDatesReadValue, fromJson: _customDatesFromJson)
  final List<CustomDates> customDates;

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

  Map<String, dynamic> toJson() => _$OperatingHoursToJson(this);

  factory OperatingHours.fromJson(Map<String, dynamic> json) =>
      _$OperatingHoursFromJson(json);

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
