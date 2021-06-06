import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../models/operating_hours.dart';

TimeOfDay stringToTimeOfDay(String tod) {
  final format = DateFormat.jm();
  return TimeOfDay.fromDateTime(format.parse(tod));
}

String getTimeOfDayString(BuildContext context, TimeOfDay time) {
  String timeOfDay = TimeOfDay(
    hour: time.hour,
    minute: time.minute,
  ).replacing(hour: time.hourOfPeriod).format(context);
  String period = time.period == DayPeriod.am ? "AM" : "PM";

  return "$timeOfDay $period";
}

bool isValidOperatingHours(OperatingHours operatingHours) {
  return operatingHours != null &&
      operatingHours.startTime.isNotEmpty &&
      operatingHours.endTime.isNotEmpty &&
      operatingHours.repeatUnit > 0 &&
      operatingHours.repeatType.isNotEmpty &&
      operatingHours.startDates.isNotEmpty;
}

extension StringExtension on String {
  String capitalize() {
    if (this == "null" || isEmpty) return this;
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
