import 'package:intl/intl.dart' show DateFormat;
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

  List<DateTime> getRepeatedDays({DateTime startDate, int everyNDays = 1}) {
    startDate ??= DateTime.now();
    // this logic generation is pretty straightforward
    //  we add everyNDays to the startDate until next month
    final repeatedDays = <DateTime>[];
    for (var indexDay = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
        indexDay.month <= startDate.month + 1;
        indexDay = indexDay.add(Duration(days: everyNDays))) {
      // check that the days (esp. for starting date) is at least today
      if (!_isValidDate(indexDay)) continue;
      repeatedDays.add(indexDay);
    }

    return repeatedDays;
  }

  List<DateTime> getRepeatedWeekDays({
    DateTime startDate,
    int everyNWeeks = 1,
    List<int> selectedDays = const [0, 1, 2, 3, 4, 5, 6],
  }) {
    startDate ??= DateTime.now();
    // we need to make sure that the selectedDays are sorted from 0-6 (Sunday to Saturday)
    selectedDays.sort();
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
      Duration(days: (selectedDays.first - weekDay).abs()),
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
        if (!_isValidDate(indexDay)) continue;
        if (indexDay.difference(initialDate).inDays < 0) continue;

        var day = indexDay.weekday;
        // since DateTime starts at Monday (1) and ends in Sunday (7),
        // we need to convert the Sunday to 0 as our starting weekday
        if (day == 7) day = 0;
        if (selectedDays.contains(day)) repeatedDays.add(indexDay);

        // check if the final selected day (i.e, saturday) is already reached
        if (selectedDays.last == day) {
          break;
        }
      }

      // for exactly 1 year from startDate
      if (startDate.month == indexWeekDay.month &&
          startDate.year + 1 == indexWeekDay.year) break;
    }

    return repeatedDays;
  }

  List<DateTime> getRepeatedMonthDays(
      {DateTime startDate, int everyNMonths = 1}) {
    startDate ??= DateTime.now();
    final repeatedDays = <DateTime>[];

    for (var indexDay =
            DateTime(startDate.year, startDate.month, startDate.day);
        true; // this will be handled by the break check for exactly 1 year
        indexDay = Jiffy(indexDay).add(months: everyNMonths)) {
      // check that the days (esp. for starting date) is at least today
      if (!_isValidDate(indexDay)) continue;

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

    return repeatedDays;
  }
}
