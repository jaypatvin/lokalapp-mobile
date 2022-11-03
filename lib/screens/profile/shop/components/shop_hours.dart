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
    final isInOpeningHours = useMemoized<bool>(
      () {
        final now = DateTime.now();
        final opening = stringToTimeOfDay(shopOperatingHours.startTime);
        final closing = stringToTimeOfDay(shopOperatingHours.endTime);
        final timeNow = TimeOfDay.fromDateTime(now);

        final openingInMinutes = (opening.hour * 60) + opening.minute;
        final closingInMinutes = (closing.hour * 60) + closing.minute;
        final nowInMinutes = (timeNow.hour * 60) + timeNow.minute;

        return openingInMinutes <= nowInMinutes &&
            nowInMinutes <= closingInMinutes;
      },
      [shopOperatingHours],
    );

    final selectableDates = useMemoized<List<DateTime>>(() {
      return ScheduleGenerator()
          .generateSchedule(shopOperatingHours)
          .selectableDates;
    }, [
      shopOperatingHours,
      isInOpeningHours,
    ]);

    final isOpen = useMemoized<bool>(
      () {
        if (!isInOpeningHours) return false;
        final now = DateTime.now();

        return selectableDates.any((date) =>
            date.year == now.year &&
            date.month == now.month &&
            // ignore: require_trailing_commas
            now.day == date.day);
      },
      [selectableDates, isInOpeningHours],
    );

    final openingAt = useMemoized<String>(
      () {
        if (isOpen) return '';

        final tomorrow = DateTime.now().add(const Duration(days: 1));

        if (selectableDates.any((date) =>
            date.year == tomorrow.year &&
            date.month == tomorrow.month &&
            // ignore: require_trailing_commas
            date.day == tomorrow.day)) {
          return 'tomorrow';
        }

        final now = DateTime.now();
        selectableDates.sort();

        final nearestAvailableDate = selectableDates.reduce((a, b) {
          if (a.difference(now).isNegative) {
            return b;
          }
          return a;
        });
        return DateFormat('MMMM dd').format(nearestAvailableDate);
      },
      [shopOperatingHours, isOpen, selectableDates],
    );

    if (isOpen) {
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
                .subtitle2
                ?.copyWith(color: kPinkColor),
          ),
          Text(
            'Opens $openingAt at ${shopOperatingHours.startTime} ',
            style: Theme.of(context).textTheme.subtitle2,
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
