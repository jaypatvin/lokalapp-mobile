import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

import 'src/calendar_carousel.dart';
import 'src/calendar_default_widget.dart';
import 'src/calendar_widgets.dart';

class CalendarPicker extends HookWidget {
  const CalendarPicker({
    Key? key,
    required this.onDayPressed,
    this.selectedDate,
    this.selectableDates = const [],
    this.selectableDays = const [],
    this.markedDates = const [],
    this.onNonSelectableDayPressed,
    this.startDate,
    this.weekdayWidgetBuilder,
  }) : super(key: key);

  final List<DateTime> selectableDates;
  final List<DateTime> markedDates;
  final List<int> selectableDays;
  final DateTime? selectedDate;
  final DateTime? startDate;
  final void Function(DateTime date) onDayPressed;
  final void Function(DateTime date)? onNonSelectableDayPressed;
  final Widget Function(int)? weekdayWidgetBuilder;

  @override
  Widget build(BuildContext context) {
    final _calendarController = useMemoized(
      () => CalendarController(),
    );

    return CalendarCarousel(
      controller: _calendarController,
      dateFormat: DateFormat.yMMM(
        Intl.defaultLocale,
      ),
      day: DateTime.now().day,
      headerWidgetBuilder: (controller, dateFormat, dateTime) {
        return CalendarDefaultHeader(
          calendarController: _calendarController,
          dateTime: dateTime,
          dateFormat: dateFormat,
        );
      },
      weekdayWidgetBuilder: weekdayWidgetBuilder ??
          (weekday) {
            return LokalCalendarWeekday(
              weekday: weekday,
              dateFormat: DateFormat.yMMM(Intl.defaultLocale),
              textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            );
          },
      dayWidgetBuilder: (date, isLastMonthDay, isNextMonthDay) {
        final _startDate = startDate ?? DateTime.now();
        final isToday = _startDate.year == date.year &&
            _startDate.month == date.month &&
            _startDate.day == date.day;

        final bool isInSelectabledDates = selectableDates.any((e) {
          return e.year == date.year &&
              e.month == date.month &&
              e.day == date.day;
        });

        final bool isInSelectableDays = selectableDays.any((e) {
          if (e == 0) {
            return date.weekday == 7;
          }
          return e == date.weekday;
        });

        final bool isAfterStartDate =
            _startDate.difference(date).isNegative && !isToday;

        final bool isSelectable =
            (isInSelectabledDates || isInSelectableDays) && isAfterStartDate;

        return LokalCalendarDay(
          dateTime: date,
          isLastMonthDay: isLastMonthDay,
          isNextMonthDay: isNextMonthDay,
          isSelectable: isSelectable,
          isSelected: selectedDate?.year == date.year &&
              selectedDate?.month == date.month &&
              selectedDate?.day == date.day,
          isMarked: markedDates.any(
            (e) =>
                e.year == date.year &&
                e.month == date.month &&
                e.day == date.day,
          ),
          onPressed: () {
            if (isSelectable) {
              onDayPressed(date);
            } else {
              onNonSelectableDayPressed?.call(date);
            }
          },
        );
      },
    );
  }
}
