import 'package:flutter/foundation.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';

import '../../models/operating_hours.dart';
import '../../widgets/schedule_picker.dart';
import '../functions.utils.dart';
import 'repeated_days_generator.dart';

class Schedule {
  static const List<String> ordinalNumbers = [
    'First',
    'Second',
    'Third',
    'Fourth',
    'Fifth'
  ];

  final RepeatChoices repeatType;
  final int? repeatUnit;
  final List<int> selectableDays;
  final List<DateTime> selectableDates;
  final DateTime startDate;
  final List<DateTime> startDates;
  final int startDayOfMonth;

  const Schedule({
    required this.repeatType,
    required this.repeatUnit,
    required this.selectableDays,
    required this.selectableDates,
    required this.startDate,
    required this.startDates,
    required this.startDayOfMonth,
  });

  Schedule copyWith({
    RepeatChoices? repeatType,
    int? repeatUnit,
    List<int>? selectableDays,
    List<DateTime>? selectableDates,
    DateTime? startDate,
    List<DateTime>? startDates,
    int? startDayOfMonth,
  }) {
    return Schedule(
      repeatType: repeatType ?? this.repeatType,
      repeatUnit: repeatUnit ?? this.repeatUnit,
      selectableDays: selectableDays ?? this.selectableDays,
      selectableDates: selectableDates ?? this.selectableDates,
      startDate: startDate ?? this.startDate,
      startDates: startDates ?? this.startDates,
      startDayOfMonth: startDayOfMonth ?? this.startDayOfMonth,
    );
  }

  @override
  String toString() {
    return 'repeatType: $repeatType, repeatUnit: $repeatUnit, '
        'selectableDays: $selectableDays, selectableDates: $selectableDates '
        'startDate: $startDate, startDates: $startDates, startDayOfMonth: '
        '$startDayOfMonth';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Schedule &&
        other.repeatType == repeatType &&
        other.repeatUnit == repeatUnit &&
        listEquals(other.selectableDays, selectableDays) &&
        listEquals(other.selectableDates, selectableDates) &&
        other.startDate == startDate &&
        listEquals(other.startDates, startDates) &&
        other.startDayOfMonth == startDayOfMonth;
  }

  @override
  int get hashCode {
    return repeatType.hashCode ^
        repeatUnit.hashCode ^
        selectableDays.hashCode ^
        selectableDates.hashCode ^
        startDate.hashCode ^
        startDates.hashCode ^
        startDayOfMonth.hashCode;
  }
}

/// Could be a function that should return a `Schedule` class/interface
/// that is used throughout the app.
class ScheduleGenerator {
  final _generator = RepeatedDaysGenerator();

  /// Returns the `RepeatChoices` from the `String repeatType` from the API
  ///
  /// The string values should only include: `month`, `day`, `week`, and
  /// `"unit"-"type"`
  RepeatChoices getRepeatChoicesFromString(String repeatType) {
    var repeatChoice = RepeatChoices.month;
    if (repeatType.split('-').length <= 1) {
      for (final choice in RepeatChoices.values) {
        if (choice.value.toLowerCase() == repeatType) {
          repeatChoice = choice;
        }
      }
    }
    return repeatChoice;
  }

  /// Generates the initialDates for generating schedules.
  ///
  /// When repeatChoice is `week`, selectableDays is defaulted to all days.
  /// `repeatType` is only needed when repeat choice is `month`.
  List<DateTime> generateInitialDates({
    required RepeatChoices repeatChoice,
    required DateTime? startDate,
    required int? repeatEveryNUnit,
    required List<int> selectableDays,
    String? repeatType,
  }) {
    switch (repeatChoice) {
      case RepeatChoices.day:
        return _generator.getRepeatedDays(
          startDate: startDate,
          everyNDays: repeatEveryNUnit!,
        );
      case RepeatChoices.week:
        return _generator
            .getRepeatedWeekDays(
              startDate: startDate,
              everyNWeeks: repeatEveryNUnit!,
              selectedDays: selectableDays,
            )
            .toSet()
            .toList()
          ..sort();
      case RepeatChoices.month:
        final type = repeatType!.split('-');
        // The user used the ordinal picker
        if (type.length > 1) {
          final ordinal = int.tryParse(type[0]);
          return _generator.getRepeatedMonthDaysByNthDay(
            everyNMonths: repeatEveryNUnit!,
            ordinal: ordinal,
            weekday: en_USSymbols.SHORTWEEKDAYS.indexOf(type[1].capitalize()),
            month: startDate!.month,
          );
        }
        return _generator.getRepeatedMonthDaysByStartDate(
          startDate: startDate,
          everyNMonths: repeatEveryNUnit!,
        );
      default:
        return [];
    }
  }

  /// Returns a generated list of dates from existing operating-hours for 1 year.
  ///
  /// This function already filters out unavailable dates and adds custom ones.
  List<DateTime> getSelectableDates(OperatingHours operatingHours) {
    List<DateTime> selectableDates = <DateTime>[];
    RepeatChoices? repeatChoice;
    bool isNDays = false;
    final repeatType = operatingHours.repeatType;
    if (repeatType.split('-').length > 1) {
      isNDays = true;
      repeatChoice = RepeatChoices.month;
    }
    for (final element in RepeatChoices.values) {
      if (element.value.toLowerCase() == operatingHours.repeatType) {
        repeatChoice = element;
      }
    }

    final repeatUnit = operatingHours.repeatUnit;
    final startDate = DateFormat('yyyy-MM-dd').parse(
      operatingHours.startDates.first,
    );

    switch (repeatChoice) {
      case RepeatChoices.day:
        selectableDates = _generator.getRepeatedDays(
          startDate: startDate,
          everyNDays: repeatUnit,
          validate: false,
        );
        break;
      case RepeatChoices.week:
        final selectableDays = <int>[];
        for (final element in operatingHours.startDates) {
          final date = DateFormat('yyyy-MM-dd').parse(element);
          var weekday = date.weekday;
          if (weekday == 7) weekday = 0;
          selectableDays.add(weekday);
        }
        selectableDates = _generator.getRepeatedWeekDays(
          startDate: startDate,
          everyNWeeks: repeatUnit,
          selectedDays: selectableDays,
          validate: false,
        );
        final startDates = <String>[];
        for (int i = 0; i < selectableDays.length; i++) {
          startDates.add(DateFormat('yyyy-MM-dd').format(selectableDates[i]));
        }
        break;
      case RepeatChoices.month:
        if (isNDays) {
          final type = operatingHours.repeatType.split('-');
          selectableDates = _generator.getRepeatedMonthDaysByNthDay(
            everyNMonths: operatingHours.repeatUnit,
            ordinal: int.parse(type[0]),
            weekday: en_USSymbols.SHORTWEEKDAYS.indexOf(type[1].capitalize()),
            month: DateTime.now().month,
          );
        } else {
          selectableDates = _generator.getRepeatedMonthDaysByStartDate(
            startDate: startDate,
            everyNMonths: repeatUnit,
            validate: false,
          );
        }

        break;
      default:
        // do nothing
        break;
    }

    final unavailableDates = <DateTime>[];
    for (final element in operatingHours.unavailableDates) {
      unavailableDates.add(DateFormat('yyyy-MM-dd').parse(element));
    }
    selectableDates
        .removeWhere((element) => unavailableDates.contains(element));

    for (final element in operatingHours.customDates) {
      final date = DateFormat('yyyy-MM-dd').parse(element.date);
      if (!selectableDates.contains(date)) {
        selectableDates.add(date);
      }
    }

    return selectableDates;
  }

  Schedule generateSchedule(OperatingHours operatingHours) {
    final repeatUnit = operatingHours.repeatUnit;

    final selectableDays = <int>{};
    final startDates = <DateTime>[];
    // Day and week:
    for (final element in operatingHours.startDates) {
      final date = DateFormat('yyyy-MM-dd').parse(element);
      int weekday = date.weekday;
      if (weekday == 7) weekday = 0;
      selectableDays.add(weekday);
      startDates.add(date);
    }
    final startDate = DateFormat('yyyy-MM-dd').parse(
      operatingHours.startDates.first,
    );

    // Month:
    int startDayOfMonth = 0;

    final repeatType = operatingHours.repeatType;
    var repeatChoice = RepeatChoices.day;
    if (repeatType.split('-').length > 1) {
      repeatChoice = RepeatChoices.month;
    } else {
      for (final element in RepeatChoices.values) {
        if (element.value.toLowerCase() == operatingHours.repeatType) {
          repeatChoice = element;
        }
      }
      startDayOfMonth = startDate.day;
    }

    return Schedule(
      repeatType: repeatChoice,
      repeatUnit: repeatUnit,
      selectableDays: selectableDays.toList(),
      startDate: startDate,
      startDates: startDates,
      startDayOfMonth: startDayOfMonth,
      selectableDates: getSelectableDates(operatingHours),
    );
  }

  List<DateTime> getWeekDayStartDates(
    DateTime? startDate,
    List<int> selectedDays, {
    int everyNWeeks = 1,
    bool validate = false,
  }) {
    return _generator.getRepeatedWeekDays(
      startDate: startDate,
      selectedDays: selectedDays,
      everyNWeeks: everyNWeeks,
      maxLength: selectedDays.length,
    );
  }
}
