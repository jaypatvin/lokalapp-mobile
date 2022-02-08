import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'calendar_carousel.dart' show CalendarController;

class CalendarDefaultWeekday extends StatelessWidget {
  final int weekday;
  final DateFormat dateFormat;
  final TextStyle? textStyle;
  const CalendarDefaultWeekday({
    Key? key,
    required this.weekday,
    required this.dateFormat,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final werapWeekday = weekday % 7;
    final msg = dateFormat.dateSymbols.STANDALONESHORTWEEKDAYS[werapWeekday];
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Center(
          child: Text(msg, textAlign: TextAlign.center, style: textStyle),
        ),
      ),
    );
  }
}

class CalendarDefaultDay extends StatelessWidget {
  final DateTime dateTime;
  final bool isLastMonthDay;
  final bool isNextMonthDay;
  const CalendarDefaultDay({
    Key? key,
    required this.dateTime,
    required this.isLastMonthDay,
    required this.isNextMonthDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3),
      child: Container(
        color:
            (isLastMonthDay || isNextMonthDay) ? Colors.black12 : Colors.green,
        child: Center(
          child: Text(
            '${dateTime.day}',
            style: TextStyle(
              color: (isLastMonthDay || isNextMonthDay)
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class CalendarDefaultHeader extends StatelessWidget {
  final CalendarController calendarController;
  final DateTime dateTime;
  final DateFormat dateFormat;
  const CalendarDefaultHeader({
    Key? key,
    required this.calendarController,
    required this.dateTime,
    required this.dateFormat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              calendarController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
          Expanded(
            child: Text(
              dateFormat.format(dateTime),
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              calendarController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          )
        ],
      ),
    );
  }
}
