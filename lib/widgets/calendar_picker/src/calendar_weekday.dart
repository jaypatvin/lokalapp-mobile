import 'package:flutter/material.dart';

typedef WeekdayWidgetBuilder = Widget Function(int weekday);

class CalendarWeekday extends StatelessWidget {
  const CalendarWeekday(
    this.firstDayOfWeek, {
    super.key,
    required this.builder,
  }) : assert(firstDayOfWeek >= 0 && firstDayOfWeek <= 7);

  final int firstDayOfWeek;
  final WeekdayWidgetBuilder builder;

  List<Widget> _renderWeekDays() {
    final list = [];
    for (int i = 0; i < 7; i++) {
      var weekday = (firstDayOfWeek + i) % 7;
      if (weekday == 0) weekday = 7;
      list.add(weekday);
    }
    return list.map((i) => builder(i)).toList();
  }

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _renderWeekDays(),
      );
}
