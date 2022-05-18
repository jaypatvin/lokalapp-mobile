import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../utils/constants/themes.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/calendar_picker/calendar_picker.dart';

class SubscriptionScheduleCalendar extends HookWidget {
  /// The calendar picker to be displayed to manually resolve the conflicts.
  const SubscriptionScheduleCalendar({
    Key? key,
    required this.onDayPressed,
    required this.onCancel,
    required this.onConfirm,
    required this.markedDates,
    required this.selectableDates,
    required this.onNonSelectableDayPressed,
    required this.displayWarning,
    this.selectedDate,
  }) : super(key: key);

  final void Function(DateTime) onDayPressed;
  final void Function(DateTime) onNonSelectableDayPressed;
  final void Function() onConfirm;
  final void Function() onCancel;
  final List<DateTime?> markedDates;
  final List<DateTime?> selectableDates;
  final bool displayWarning;
  final DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(21),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 23),
            Text(
              'Subscription Calendar',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return CalendarPicker(
                    selectableDates:
                        selectableDates.whereType<DateTime>().toList(),
                    onDayPressed: (day) => setState(() => onDayPressed(day)),
                    markedDates: markedDates.whereType<DateTime>().toList(),
                    onNonSelectableDayPressed: onNonSelectableDayPressed,
                    selectedDate: selectedDate,
                  );
                },
              ),
            ),
            if (displayWarning)
              Container(
                margin: const EdgeInsets.only(top: 30),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: const [
                    Icon(
                      MdiIcons.alertCircle,
                      color: kPinkColor,
                    ),
                    SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        'This shop will be closed on the date you selected. '
                        'Please pick a different date to have your orders '
                        'delivered.',
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 29),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: AppButton.transparent(
                      text: 'Cancel',
                      onPressed: onCancel,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppButton.filled(
                      text: 'Confirm',
                      onPressed: onConfirm,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
