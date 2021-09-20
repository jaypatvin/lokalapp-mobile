import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';
import 'package:lokalapp/widgets/schedule_picker.dart';

import '../../models/operating_hours.dart';

import '../functions.utils.dart';
import 'repeated_days_generator.dart';

// TODO: return a class/interface
class Schedule {
  static const List<String> ordinalNumbers = [
    "First",
    "Second",
    "Third",
    "Fourth",
    "Fifth"
  ];

  final RepeatChoices repeatType;
  final int repeatUnit;
  final List<int> selectableDays;
  final List<DateTime> selectableDates;
  final DateTime startDate;
  final List<DateTime> startDates;
  final int startDayOfMonth;

  const Schedule({
    @required this.repeatType,
    @required this.repeatUnit,
    @required this.selectableDays,
    @required this.selectableDates,
    @required this.startDate,
    @required this.startDates,
    @required this.startDayOfMonth,
  });

  Schedule copyWith({
    RepeatChoices repeatType,
    int repeatUnit,
    List<int> selectableDays,
    List<DateTime> selectableDates,
    DateTime startDate,
    List<DateTime> startDates,
    int startDayOfMonth,
    TimeOfDay opening,
    TimeOfDay closing,
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

  List<DateTime> generateInitialDates({
    @required RepeatChoices repeatChoice,
    @required DateTime startDate,
    @required int repeatEveryNUnit,
    List<int> selectableDays,
    String repeatType,
  }) {
    switch (repeatChoice) {
      case RepeatChoices.day:
        return _generator.getRepeatedDays(
          startDate: startDate,
          everyNDays: repeatEveryNUnit,
        );
      case RepeatChoices.week:
        return _generator.getRepeatedWeekDays(
          startDate: startDate,
          everyNWeeks: repeatEveryNUnit,
          selectedDays: selectableDays,
        );
      case RepeatChoices.month:
        final type = repeatType.split("-");
        // The user used the ordinal picker
        if (type.length > 1) {
          final _ordinal = int.tryParse(type[0]);
          return _generator.getRepeatedMonthDaysByNthDay(
            everyNMonths: repeatEveryNUnit,
            ordinal: _ordinal,
            weekday: en_USSymbols.SHORTWEEKDAYS.indexOf(type[1].capitalize()),
            month: startDate.month,
          );
        }
        return _generator.getRepeatedMonthDaysByStartDate(
          startDate: startDate,
          everyNMonths: repeatEveryNUnit,
        );
      default:
        return [];
    }
  }

  /// Returns a generated list of dates from existing operating-hours.
  ///
  /// This function already filters out unavailable dates and adds custome ones.
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

    switch (repeatChoice) {
      case RepeatChoices.day:
        selectableDates = _generator.getRepeatedDays(
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
        selectableDates = _generator.getRepeatedWeekDays(
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

  Schedule generateSchedule(OperatingHours operatingHours) {
    final _repeatUnit = operatingHours.repeatUnit;

    final _selectableDays = <int>[];
    final _startDates = <DateTime>[];

    // Day and week:
    operatingHours.startDates.forEach((element) {
      final date = DateFormat("yyyy-MM-dd").parse(element);
      int weekday = date.weekday;
      if (weekday == 7) weekday = 0;
      _selectableDays.add(weekday);
      _startDates.add(date);
    });
    final _startDate = DateFormat("yyyy-MM-dd").parse(
      operatingHours.startDates.first,
    );

    // Month:
    var _startDayOfMonth = _startDate.day;
    final repeatType = operatingHours.repeatType;
    var _repeatChoice = RepeatChoices.day;
    if (repeatType.split("-").length > 1) {
      _repeatChoice = RepeatChoices.month;
      _startDayOfMonth = 0;
    } else {
      RepeatChoices.values.forEach((element) {
        if (element.value?.toLowerCase() == operatingHours.repeatType) {
          _repeatChoice = element;
        }
      });
    }

    return Schedule(
      repeatType: _repeatChoice,
      repeatUnit: _repeatUnit,
      selectableDays: _selectableDays,
      startDate: _startDate,
      startDates: _startDates,
      startDayOfMonth: _startDayOfMonth,
      selectableDates: getSelectableDates(operatingHours),
    );
  }
}
