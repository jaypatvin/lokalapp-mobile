import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../calendar_picker.dart';
import 'default_styles.dart' show defaultWeekdayTextStyle;

class WeekdayRow extends StatelessWidget {
  const WeekdayRow(
    this.firstDayOfWeek, {
    required this.weekdayFormat,
    required this.weekdayMargin,
    required this.weekdayPadding,
    required this.weekdayBackgroundColor,
    required this.weekdayTextStyle,
    required this.localeDate,
  });

  final WeekdayFormat weekdayFormat;
  final EdgeInsets weekdayMargin;
  final EdgeInsets weekdayPadding;
  final Color weekdayBackgroundColor;
  final TextStyle weekdayTextStyle;
  final DateFormat? localeDate;
  final int? firstDayOfWeek;

  Widget _weekdayContainer(int? weekday, String weekDayName) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: weekdayBackgroundColor),
          color: weekdayBackgroundColor,
        ),
        margin: weekdayMargin,
        padding: weekdayPadding,
        child: Center(
          child: DefaultTextStyle(
            style: defaultWeekdayTextStyle,
            child: Text(
              weekDayName,
              semanticsLabel: weekDayName,
              style: weekdayTextStyle,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _renderWeekDays() {
    final List<Widget> list = [];

    /// because of number of days in a week is 7, so it would be easier to count it til 7.
    // ignore: avoid_multiple_declarations_per_line
    for (int? i = firstDayOfWeek, count = 0;
        count! < 7;
        i = (i + 1) % 7, count++) {
      String weekDay;

      switch (weekdayFormat) {
        case WeekdayFormat.weekdays:
          weekDay = localeDate!.dateSymbols.WEEKDAYS[i!];
          break;
        case WeekdayFormat.standalone:
          weekDay = localeDate!.dateSymbols.STANDALONEWEEKDAYS[i!];
          break;
        case WeekdayFormat.short:
          weekDay = localeDate!.dateSymbols.SHORTWEEKDAYS[i!];
          break;
        case WeekdayFormat.standaloneShort:
          weekDay = localeDate!.dateSymbols.STANDALONESHORTWEEKDAYS[i!];
          break;
        case WeekdayFormat.narrow:
          weekDay = localeDate!.dateSymbols.NARROWWEEKDAYS[i!];
          break;
        case WeekdayFormat.standaloneNarrow:
          weekDay = localeDate!.dateSymbols.STANDALONENARROWWEEKDAYS[i!];
          break;
        default:
          weekDay = localeDate!.dateSymbols.STANDALONEWEEKDAYS[i!];
          break;
      }
      list.add(_weekdayContainer(count, weekDay));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _renderWeekDays(),
    );
  }
}
