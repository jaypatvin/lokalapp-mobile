import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

TimeOfDay stringToTimeOfDay(String tod) {
  final format = DateFormat.jm(); //"6:00 AM"
  return TimeOfDay.fromDateTime(format.parse(tod));
}

String getTimeOfDayString(BuildContext context, TimeOfDay time) {
  String timeOfDay = TimeOfDay(
    hour: time.hour,
    minute: time.minute,
  ).replacing(hour: time.hourOfPeriod).format(context);
  String period = time.period == DayPeriod.am ? "AM" : "PM";

  return '$timeOfDay $period';
}
