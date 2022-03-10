import 'package:flutter/foundation.dart';

import '../../models/operating_hours.dart';

class OperatingHoursRequestBody {
  const OperatingHoursRequestBody({
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

  OperatingHoursRequestBody copyWith({
    String? startTime,
    String? endTime,
    String? repeatType,
    int? repeatUnit,
    List<String>? startDates,
    List<String>? unavailableDates,
    List<CustomDates>? customDates,
  }) {
    return OperatingHoursRequestBody(
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
    assert(startTime.isNotEmpty, 'startTime should not be empty');
    assert(endTime.isNotEmpty, 'endTime should not be empty');
    assert(repeatType.isNotEmpty, 'repeatType should not be empty');
    assert(repeatUnit > 0, 'repeatUnit should be greater than 0');

    return {
      'start_time': startTime,
      'end_time': endTime,
      'repeat_type': repeatType,
      'repeat_unit': repeatUnit,
      'start_dates': startDates,
      'unavailable_dates': unavailableDates,
      'custom_dates': customDates.map((x) => x.toJson()).toList(),
    }..removeWhere((key, value) {
        if (key.isEmpty || value == null) return true;

        if (value is String) {
          return value.isEmpty;
        } else if (value is List) {
          return value.isEmpty;
        }

        return false;
      });
  }

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

    return other is OperatingHoursRequestBody &&
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

class OperatingHoursBody extends ChangeNotifier {
  OperatingHoursRequestBody _body = const OperatingHoursRequestBody();
  OperatingHoursRequestBody get body => _body;

  Map<String, dynamic> get data => _body.toMap();

  void update({
    String? startTime,
    String? endTime,
    String? repeatType,
    int? repeatUnit,
    List<String>? startDates,
    List<String>? unavailableDates,
    List<CustomDates>? customDates,
    bool notify = true,
  }) {
    _body = _body.copyWith(
      startTime: startTime,
      endTime: endTime,
      startDates: startDates,
      repeatType: repeatType,
      repeatUnit: repeatUnit,
      unavailableDates: unavailableDates,
      customDates: customDates,
    );
    if (notify) notifyListeners();
  }

  void clear({bool notify = true}) {
    _body = const OperatingHoursRequestBody();
    if (notify) notifyListeners();
  }
}
