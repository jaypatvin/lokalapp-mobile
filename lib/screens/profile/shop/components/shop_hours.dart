import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

import '../../../../models/operating_hours.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../utils/functions.utils.dart';
import '../../../../utils/repeated_days_generator/schedule_generator.dart';

class ShopHours extends HookWidget {
  const ShopHours({
    Key? key,
    required this.shopOperatingHours,
  }) : super(key: key);
  final OperatingHours shopOperatingHours;

  @override
  Widget build(BuildContext context) {
    final _isNowBeforeClosing = useMemoized<bool>(
      () {
        final _now = DateTime.now();
        final _closing = stringToTimeOfDay(shopOperatingHours.endTime);
        final _timeNow = TimeOfDay.fromDateTime(_now);

        final _closingInMinutes = (_closing.hour * 60) + _closing.minute;
        final _nowInMinutes = (_timeNow.hour * 60) + _timeNow.minute;

        if (_nowInMinutes >= _closingInMinutes) {
          return false;
        }
        return true;
      },
      [shopOperatingHours],
    );

    final _selectableDates = useMemoized<List<DateTime>>(() {
      return ScheduleGenerator()
          .generateSchedule(shopOperatingHours)
          .selectableDates;
    }, [
      shopOperatingHours,
      _isNowBeforeClosing,
    ]);

    final _isOpen = useMemoized<bool>(
      () {
        if (!_isNowBeforeClosing) return false;
        final _now = DateTime.now();

        return _selectableDates.any((date) =>
            date.year == _now.year &&
            date.month == _now.month &&
            // ignore: require_trailing_commas
            _now.day == date.day);
      },
      [_selectableDates, _isNowBeforeClosing],
    );

    final _openingAt = useMemoized<String>(
      () {
        if (_isOpen) return '';

        final _tomorrow = DateTime.now().add(const Duration(days: 1));

        if (_selectableDates.any((date) =>
            date.year == _tomorrow.year &&
            date.month == _tomorrow.month &&
            // ignore: require_trailing_commas
            date.day == _tomorrow.day)) {
          return 'tomorrow';
        }

        final _now = DateTime.now();
        _selectableDates.sort();

        final _nearestAvailableDate = _selectableDates.reduce((a, b) {
          if (a.difference(_now).isNegative) {
            return b;
          }
          return a;
        });
        return DateFormat('MMMM dd').format(_nearestAvailableDate);
      },
      [shopOperatingHours, _isOpen, _selectableDates],
    );

    if (_isOpen) {
      return SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'OPEN',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(color: kTealColor),
            ),
            Text(
              'from ${shopOperatingHours.startTime} '
              '- ${shopOperatingHours.endTime}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      );
    }

    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'CLOSED',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(color: kPinkColor),
          ),
          Text(
            'Opens $_openingAt at ${shopOperatingHours.startTime} '
            '- ${shopOperatingHours.endTime}',
            style: Theme.of(context).textTheme.subtitle1,
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
