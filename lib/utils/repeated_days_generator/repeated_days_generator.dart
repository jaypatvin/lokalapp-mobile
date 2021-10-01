import 'package:flutter/foundation.dart';
import 'package:jiffy/jiffy.dart';

class RepeatedDaysGenerator {
  static RepeatedDaysGenerator _generator;

  static RepeatedDaysGenerator get instance {
    _generator ??= RepeatedDaysGenerator();
    return _generator;
  }

  bool _isValidDate(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now).inDays;

    return diff >= 0;
  }

  List<DateTime> getRepeatedDays({
    @required DateTime startDate,
    int everyNDays = 1,
    bool validate = true,
  }) {
    assert(everyNDays > 0);
    startDate ??= DateTime.now();
    // this logic generation is pretty straightforward
    //  we add everyNDays to the startDate until next month
    final repeatedDays = <DateTime>[];
    for (var indexDay = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
        true;
        indexDay = indexDay.add(Duration(days: everyNDays))) {
      // check that the days (esp. for starting date) is at least today
      if (!_isValidDate(indexDay) && validate) continue;
      repeatedDays.add(indexDay);

      // for exactly 1 year from startDate
      if (startDate.month == indexDay.month &&
          startDate.year + 1 == indexDay.year) break;
    }

    return [
      ...{...repeatedDays}
    ];
  }

  List<DateTime> getRepeatedWeekDays({
    @required DateTime startDate,
    int everyNWeeks = 1,
    List<int> selectedDays = const [0, 1, 2, 3, 4, 5, 6],
    bool validate = true,
    int maxLength,
  }) {
    assert(everyNWeeks > 0);
    startDate ??= DateTime.now();
    // we need to make sure that the selectedDays are sorted from 0-6 (Sunday to Saturday)
    final _selectedDays = [
      ...{...selectedDays}
    ]..sort();

    final repeatedDays = <DateTime>[];

    // if the selected startDate.day is not equal to the first selected weekday,
    // we'll reset the startDay to the first selected weekday
    // for example:
    // if the user chooses MWF and its start-date starts at tuesday,
    // we need to make sure to start at monday for the iteration or
    // else we'll be skipping Monday since we iterate every week (7 days)
    var initialDate = startDate;
    var weekDay = startDate.weekday;
    if (weekDay == 7) weekDay = 0;
    startDate = startDate.subtract(
      Duration(days: (_selectedDays.first - weekDay).abs()),
    );

    // we'll need to iterate through everyweek from the startDate (by adding 7 days every iteration)
    // we'll do this for every week until next year for the same startDate
    for (var indexWeekDay =
            DateTime(startDate.year, startDate.month, startDate.day);
        true; // this will be handled by the break check for exactly 1 year
        indexWeekDay = indexWeekDay.add(Duration(days: 7 * everyNWeeks))) {
      // we'll loop through every days of the week PER WEEK
      for (var indexDay =
              DateTime(indexWeekDay.year, indexWeekDay.month, indexWeekDay.day);
          true;
          indexDay = indexDay.add(Duration(days: 1))) {
        // check that the days (esp. for starting date) is at least today
        if (!_isValidDate(indexDay) && validate) continue;
        if (indexDay.difference(initialDate).inDays < 0) continue;

        var day = indexDay.weekday;
        // since DateTime starts at Monday (1) and ends in Sunday (7),
        // we need to convert the Sunday to 0 as our starting weekday
        if (day == 7) day = 0;
        if (_selectedDays.contains(day)) repeatedDays.add(indexDay);

        // check if the final selected day (i.e, saturday) is already reached
        if (_selectedDays.last == day ||
            (maxLength != null && repeatedDays.length == maxLength)) {
          break;
        }
      }

      // for exactly 1 year from startDate
      if ((startDate.month == indexWeekDay.month &&
              startDate.year + 1 == indexWeekDay.year) ||
          (maxLength != null && repeatedDays.length == maxLength)) break;
    }

    return [
      ...{...repeatedDays}
    ];
  }

  List<DateTime> getRepeatedMonthDaysByStartDate({
    @required DateTime startDate,
    int everyNMonths = 1,
    bool validate = true,
  }) {
    assert(everyNMonths > 0);
    startDate ??= DateTime.now();
    final repeatedDays = <DateTime>[];

    for (var indexDay =
            DateTime(startDate.year, startDate.month, startDate.day);
        true; // this will be handled by the break check for exactly 1 year
        indexDay = Jiffy(indexDay).add(months: everyNMonths)) {
      // check that the days (esp. for starting date) is at least today
      if (!_isValidDate(indexDay) && validate) continue;

      // this is for days like 31
      // not every month contains a date of 31 and Feb only has up to 29 days
      if (indexDay.day != startDate.day) {
        final holderDay = DateTime(indexDay.year, indexDay.month, indexDay.day);
        // set the indexDay.day to the startDate
        // if it is a valid date, then we proceed in adding it to the list
        // otherwise, we revert the changes and continue to the next month
        indexDay = DateTime(indexDay.year, indexDay.month, startDate.day);
        if (indexDay.day != startDate.day) {
          indexDay = holderDay;
          continue;
        }
      }
      repeatedDays.add(indexDay);

      // for exactly 1 year from startDate
      if (startDate.month == indexDay.month &&
          startDate.year + 1 == indexDay.year) {
        break;
      }
    }

    return [
      ...{...repeatedDays}
    ];
  }

  List<DateTime> getRepeatedMonthDaysByNthDay({
    int everyNMonths = 1,
    int ordinal = 1, // first
    int weekday = 1, // Monday
    int month = 1, // January
  }) {
    assert(everyNMonths > 0);
    final repeatedDays = <DateTime>[];

    if (weekday == 0) weekday = 7;
    var startDate = DateTime(DateTime.now().year, month, 1);

    // we need to start at the first day of the month to be able to determine
    // the "nth day" of the month
    // we'll then iterate to the next month on the same day (first day) until
    // next year on the same month
    for (var indexDay = startDate;
        true;
        indexDay = Jiffy(indexDay).add(months: 1),) {
      var now = DateTime(indexDay.year, indexDay.month, indexDay.day);
      var count = 0;
      var nextMonth = false;

      // here, we'll count how many day (i.e., Mondays) we've gone through
      // 2nd Monday will mean that we count 2 Mondays for the month
      start:
      while (count < ordinal) {
        while (true) {
          // this is for the rare instances where users will pick 5th as the
          // option, where most months only have 4 weeks
          if (now.month > indexDay.month || now.year > indexDay.year) {
            nextMonth = true;
            break start;
          }
          if (now.weekday == weekday) {
            count++;
            if (count < ordinal) now = now.add(Duration(days: 1));
            break;
          }
          now = now.add(Duration(days: 1));
        }
      }

      if (!nextMonth) {
        repeatedDays.add(now);
      }

      // for exactly 1 year from startDate
      if (startDate.month == indexDay.month &&
          startDate.year + 1 == indexDay.year) {
        break;
      }
    }

    return [
      ...{...repeatedDays}
    ];
  }
}
