import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../state/views/hook.view.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../view_models/activity/subscriptions/seller_subscription_schedule.vm.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/calendar_picker/calendar_picker.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/overlays/constrained_scrollview.dart';
import '../../../../widgets/schedule_picker.dart';
import '../subscription_schedule/subscription_schedule.product_card.dart';

class SellerSubscriptionScheduleView
    extends HookView<SellerSubscriptionScheduleViewModel> {
  @override
  Widget render(
    BuildContext context,
    SellerSubscriptionScheduleViewModel vm,
  ) {
    final _repeatUnitFocusNode = useFocusNode();
    final _selectedDate = useState<DateTime?>(null);

    final _onDayPressed = useCallback<void Function(DateTime date)>(
      (date) {
        final _date = _selectedDate.value;
        if (_date?.year == date.year &&
            _date?.month == date.month &&
            _date?.day == date.day) {
          _selectedDate.value = null;
        } else {
          _selectedDate.value = date;
        }
      },
      [_selectedDate],
    );

    final _displayCalendar = useCallback(
      () async {
        return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext ctx) {
            return StatefulBuilder(
              builder: (_ctx, setState) {
                return _SubscriptionScheduleCalendar(
                  selectableDates: vm.productSelectableDates,
                  markedDates: vm.markedDates,
                  displayWarning: vm.displayWarning,
                  onConfirm: () {
                    Navigator.pop(ctx, true);
                  },
                );
              },
            );
          },
        );
      },
      [vm, _onDayPressed],
    );

    return Scaffold(
      appBar: const CustomAppBar(
        titleText: 'Subscription Schedule',
        titleStyle: TextStyle(color: Colors.black),
        leadingColor: Colors.black,
        backgroundColor: Colors.transparent,
      ),
      body: ConstrainedScrollView(
        child: KeyboardActions(
          disableScroll: true,
          config: KeyboardActionsConfig(
            nextFocus: false,
            actions: [
              KeyboardActionsItem(
                focusNode: _repeatUnitFocusNode,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SubscriptionScheduleProductCard(
                  product: vm.product,
                  quantity: vm.quantity,
                ),
                SizedBox(height: 10.0.h),
                SchedulePicker(
                  header: 'Schedule',
                  description: 'These are the dates the products are set to be '
                      'picked-up or delivered.',
                  repeatUnitFocusNode: _repeatUnitFocusNode,
                  onRepeatTypeChanged: (_) => {},
                  onStartDatesChanged: (_, __) {},
                  onRepeatUnitChanged: (_) {},
                  onSelectableDaysChanged: (_) {},
                  repeatabilityChoices: vm.repeatabilityChoices,
                  operatingHours: vm.operatingHours,
                  editable: false,
                ),
                const Spacer(),
                SizedBox(height: 10.0.h),
                if (vm.displayWarning)
                  Row(
                    children: [
                      const Icon(
                        MdiIcons.alertCircle,
                        color: kPinkColor,
                      ),
                      SizedBox(width: 10.0.w),
                      Expanded(
                        child: Text(
                          'Please wait for the buyer to manually reschedule '
                          'the following dates. Otherwise, the orders on these '
                          'dates will not push through.',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      )
                    ],
                  ),
                if (vm.displayWarning) SizedBox(height: 20.0.h),
                TextButton(
                  onPressed: () => _displayCalendar(),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(
                      double.infinity,
                      kMinInteractiveDimension,
                    ),
                    backgroundColor: Colors.transparent,
                    primary: kTealColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0.r),
                      side: const BorderSide(color: kTealColor),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'See Calendar',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: kTealColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      if (vm.displayWarning)
                        Icon(
                          MdiIcons.alertCircle,
                          color: kPinkColor,
                          size: 20.0.r,
                        )
                    ],
                  ),
                ),
                SizedBox(height: 10.0.h),
                SizedBox(
                  width: double.infinity,
                  child: AppButton.filled(
                    text: 'Confirm',
                    onPressed: () => Navigator.pop(context),
                    textStyle: TextStyle(fontSize: 20.0.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SubscriptionScheduleCalendar extends StatelessWidget {
  const _SubscriptionScheduleCalendar({
    Key? key,
    required this.onConfirm,
    required this.markedDates,
    required this.selectableDates,
    required this.displayWarning,
  }) : super(key: key);

  final void Function() onConfirm;
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
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return CalendarPicker(
                    selectableDates:
                        selectableDates.whereType<DateTime>().toList(),
                    markedDates: markedDates.whereType<DateTime>().toList(),
                    onDayPressed: (_) => {},
                  );
                },
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
                          'Please wait for the buyer to reschedule the '
                          'dates marked in red. Otherwise, their orders will '
                          'not push through for those dates.',
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                margin: EdgeInsets.symmetric(vertical: 5.0.h),
                width: double.infinity,
                child: AppButton.filled(
                  text: 'Confirm',
                  onPressed: onConfirm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
