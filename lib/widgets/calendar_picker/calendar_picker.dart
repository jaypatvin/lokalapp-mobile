import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

import 'src/calendar_carousel.dart';
import 'src/calendar_default_widget.dart';
import 'src/calendar_widgets.dart';

class CalendarPicker extends HookWidget {
  const CalendarPicker({
    super.key,
    required this.onDayPressed,
    this.selectedDate,
    this.selectableDates = const [],
    this.selectableDays = const [],
    this.markedDates = const [],
    this.onNonSelectableDayPressed,
    this.startDate,
    this.weekdayWidgetBuilder,
    this.closing,
    this.limitSelectableDates = false,
  });

  final List<DateTime> selectableDates;
  final List<DateTime> markedDates;
  final List<int> selectableDays;
  final DateTime? selectedDate;
  final DateTime? startDate;
  final void Function(DateTime date) onDayPressed;
  final void Function(DateTime date)? onNonSelectableDayPressed;
  final Widget Function(int)? weekdayWidgetBuilder;
  final TimeOfDay? closing;
  final bool limitSelectableDates;

  @override
  Widget build(BuildContext context) {
    final calendarController = useMemoized(
      () => CalendarController(),
    );

    return CalendarCarousel(
      controller: calendarController,
      dateFormat: DateFormat.yMMM(
        Intl.defaultLocale,
      ),
      day: DateTime.now().day,
      headerWidgetBuilder: (controller, dateFormat, dateTime) {
        return CalendarDefaultHeader(
          calendarController: calendarController,
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
                fontSize: 14,
                color: Colors.black,
              ),
            );
          },
      dayWidgetBuilder: (date, isLastMonthDay, isNextMonthDay) {
        final now = DateTime.now();
        final checkedStartDate = startDate ??
            DateTime(
              now.year,
              now.month,
              now.day,
            );
        final isToday = now.year == date.year &&
            now.month == date.month &&
            now.day == date.day;

        bool isBeforeClosing = true;
        if (closing != null && isToday) {
          final timeOfDayNow = TimeOfDay.fromDateTime(now);
          isBeforeClosing = (timeOfDayNow.hour * 60 + timeOfDayNow.minute) <
              (closing!.hour * 60 + closing!.minute);
        }

        final bool isInSelectableDates = selectableDates.any((e) {
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
            checkedStartDate.difference(date).inSeconds <= 0;

        final bool isInSelectable = limitSelectableDates
            ? (isInSelectableDates && isInSelectableDays)
            : (isInSelectableDates || isInSelectableDays);

        final bool isSelectable =
            isInSelectable && isAfterStartDate && isBeforeClosing;

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
