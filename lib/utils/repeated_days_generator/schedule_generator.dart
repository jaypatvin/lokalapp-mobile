import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';

import '../../models/operating_hours.dart';
import '../../screens/add_shop_screens/shop_schedule/repeat_choices.dart';
import '../functions.utils.dart';
import 'repeated_days_generator.dart';

// TODO: return a class/interface

/// Could be a function that should return a `Schedule` class/interface
/// that is used throughout the app.
class ScheduleGenerator {
  List<DateTime> getSelectableDates(OperatingHours operatingHours) {
    var selectableDates = <DateTime>[];
    RepeatChoices repeatChoice;
    bool isNDays;
    final repeatType = operatingHours.repeatType;
    if (repeatType.split("-").length > 1) {
      isNDays = true;
      repeatChoice = RepeatChoices.month;
    }
    RepeatChoices.values.forEach((element) {
      if (element.value.toLowerCase() == operatingHours.repeatType) {
        repeatChoice = element;
      }
    });

    final repeatUnit = operatingHours.repeatUnit;
    final startDate = DateFormat("yyyy-MM-dd").parse(
      operatingHours.startDates.first,
    );
    var dayGenerator = RepeatedDaysGenerator.instance;
    switch (repeatChoice) {
      case RepeatChoices.day:
        selectableDates = dayGenerator.getRepeatedDays(
          startDate: startDate,
          everyNDays: repeatUnit,
          validate: operatingHours == null,
        );
        break;
      case RepeatChoices.week:
        var selectableDays = <int>[];
        operatingHours.startDates.forEach((element) {
          var date = DateFormat("yyyy-MM-dd").parse(element);
          var weekday = date.weekday;
          if (weekday == 7) weekday = 0;
          selectableDays.add(weekday);
        });
        selectableDates = dayGenerator.getRepeatedWeekDays(
          startDate: startDate,
          everyNWeeks: repeatUnit,
          selectedDays: selectableDays,
          validate: operatingHours == null,
        );
        var startDates = <String>[];
        for (int i = 0; i < selectableDays.length; i++) {
          startDates.add(DateFormat("yyyy-MM-dd").format(selectableDates[i]));
        }
        break;
      case RepeatChoices.month:
        if (isNDays) {
          var type = operatingHours.repeatType.split("-");
          selectableDates = dayGenerator.getRepeatedMonthDaysByNthDay(
            everyNMonths: operatingHours.repeatUnit,
            ordinal: int.parse(type[0]),
            weekday: en_USSymbols.SHORTWEEKDAYS.indexOf(type[1].capitalize()),
            month: DateTime.now().month,
          );
        } else {
          selectableDates = dayGenerator.getRepeatedMonthDaysByStartDate(
            startDate: startDate,
            everyNMonths: repeatUnit,
            validate: operatingHours == null,
          );
        }

        break;
      default:
        // do nothing
        break;
    }

    final unavailableDates = <DateTime>[];
    operatingHours.unavailableDates.forEach((element) {
      unavailableDates.add(DateFormat("yyyy-MM-dd").parse(element));
    });
    selectableDates
        .removeWhere((element) => unavailableDates.contains(element));

    operatingHours.customDates.forEach((element) {
      final date = DateFormat("yyyy-MM-dd").parse(element.date);
      if (!selectableDates.contains(date)) {
        selectableDates.add(date);
      }
    });

    return selectableDates;
  }
}
