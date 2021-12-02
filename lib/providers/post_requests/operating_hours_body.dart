import 'package:flutter/foundation.dart';

import '../../models/operating_hours.dart';

class OperatingHoursBody extends ChangeNotifier {
  OperatingHoursBody();

  OperatingHours _operatingHours = OperatingHours();
  OperatingHours get operatingHours => _operatingHours;

  Map<String, dynamic> get data => _operatingHours.toMap();
  Map<String, dynamic> toMap() => _operatingHours.toMap();

  void update({
    String? startTime,
    String? endTime,
    String? repeatType,
    int? repeatUnit,
    List<String>? startDates,
    List<String>? unavailableDates,
    List<CustomDates>? customDates,
  }) {
    _operatingHours = _operatingHours.copyWith(
      startTime: startTime,
      endTime: endTime,
      startDates: startDates,
      repeatType: repeatType,
      repeatUnit: repeatUnit,
      unavailableDates: unavailableDates,
      customDates: customDates,
    );
    notifyListeners();
  }

  void clear() {
    _operatingHours = OperatingHours();
    notifyListeners();
  }

  factory OperatingHoursBody.fromMap(Map<String, dynamic> map) {
    return OperatingHoursBody();
  }
}
