import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../utils/calendar_picker/calendar_picker.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../widgets/app_button.dart';

class SubscriptionScheduleCalendar extends StatelessWidget {
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
  }) : super(key: key);

  final void Function(DateTime) onDayPressed;
  final void Function(DateTime) onNonSelectableDayPressed;
  final void Function() onConfirm;
  final void Function() onCancel;
  final List<DateTime?> markedDates;
  final List<DateTime?> selectableDates;
  final bool displayWarning;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 10.0.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0.r),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 15.0.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Subscription Calendar',
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.63,
                child: CalendarPicker(
                  selectableDates:
                      selectableDates.whereType<DateTime>().toList(),
                  onDayPressed: onDayPressed,
                  markedDates: markedDates.whereType<DateTime>().toList(),
                  onNonSelectableDayPressed: onNonSelectableDayPressed,
                  selectedDate: DateTime.now(),
                ),
              ),
              if (displayWarning)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                  child: Row(
                    children: [
                      const Icon(
                        MdiIcons.alertCircle,
                        color: kPinkColor,
                      ),
                      SizedBox(width: 2.0.w),
                      const Expanded(
                        child: Text(
                          'This shop will be closed on the date you selected. '
                          'Please pick a different date to have your orders '
                          'delivered.',
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                  margin: EdgeInsets.symmetric(vertical: 5.0.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: AppButton.transparent(
                          text: 'Cancel',
                          onPressed: onCancel,
                        ),
                      ),
                      SizedBox(width: 5.0.w),
                      Expanded(
                        child: AppButton.filled(
                          text: 'Confirm',
                          onPressed: onConfirm,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
