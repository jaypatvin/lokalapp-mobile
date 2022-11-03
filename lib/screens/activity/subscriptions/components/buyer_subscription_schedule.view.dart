import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../state/views/hook.view.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../view_models/activity/subscriptions/subscription_schedule.vm.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/overlays/constrained_scrollview.dart';
import '../../../../widgets/overlays/screen_loader.dart';
import '../../../../widgets/schedule_picker.dart';
import '../subscription_schedule/subscription_schedule.calendar.dart';
import '../subscription_schedule/subscription_schedule.product_card.dart';

class BuyerSubscriptionScheduleView
    extends HookView<ViewSubscriptionScheduleViewModel> with HookScreenLoader {
  @override
  Widget screen(
    BuildContext context,
    ViewSubscriptionScheduleViewModel vm,
  ) {
    final repeatUnitFocusNode = useFocusNode();
    final selectedDate = useState<DateTime?>(null);

    final onDayPressed = useCallback<void Function(DateTime date)>(
      (date) {
        final selectedDateValue = selectedDate.value;
        if (selectedDateValue?.year == date.year &&
            selectedDateValue?.month == date.month &&
            selectedDateValue?.day == date.day) {
          selectedDate.value = null;
        } else {
          selectedDate.value = date;
        }
      },
      [selectedDate],
    );

    final displayCalendar = useCallback(
      () async {
        return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext ctx) {
            return StatefulBuilder(
              builder: (ctx, setState) {
                bool displayWarning = vm.displayWarning;
                return SubscriptionScheduleCalendar(
                  selectedDate: selectedDate.value,
                  selectableDates: vm.productSelectableDates,
                  onDayPressed: (date) {
                    setState(() => vm.onDayPressedHandler(date));
                    if (displayWarning != vm.displayWarning) {
                      setState(() => displayWarning = vm.displayWarning);
                    }
                    onDayPressed(date);
                  },
                  onNonSelectableDayPressed: (date) {
                    setState(() => vm.onNonSelectableDayPressedHandler(date));
                    onDayPressed(date);
                  },
                  markedDates: vm.markedDates,
                  displayWarning: displayWarning,
                  onCancel: () => vm.onConflictCancel(ctx),
                  onConfirm: () {
                    // The user chose to accept their changes.
                    vm.selectedDates = [...vm.markedDates];
                    Navigator.pop(ctx, true);
                  },
                );
              },
            );
          },
        );
      },
      [vm, onDayPressed],
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
                focusNode: repeatUnitFocusNode,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SubscriptionScheduleProductCard(
                  product: vm.product,
                  quantity: vm.quantity,
                ),
                const SizedBox(height: 24),
                SchedulePicker(
                  header: 'Schedule',
                  description: 'Which dates do you want this product '
                      'to be delivered?',
                  repeatUnitFocusNode: repeatUnitFocusNode,
                  onRepeatTypeChanged: (_) {},
                  onStartDatesChanged: (_, __) {},
                  onRepeatUnitChanged: (_) {},
                  onSelectableDaysChanged: (_) {},
                  repeatabilityChoices: vm.repeatabilityChoices,
                  operatingHours: vm.operatingHours,
                  editable: false,
                ),
                const Spacer(),
                const SizedBox(height: 24),
                if (vm.displayWarning)
                  Row(
                    children: [
                      const Icon(
                        MdiIcons.alertCircle,
                        color: kPinkColor,
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          "This shop won't be able to deliver on the date/s "
                          'you set. Please manually re-schedule these orders '
                          "or else they won't be placed.",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      )
                    ],
                  ),
                if (vm.displayWarning) const SizedBox(height: 20.0),
                Container(
                  margin: const EdgeInsets.all(3),
                  child: TextButton(
                    onPressed: () => displayCalendar(),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(
                        double.infinity,
                        43,
                      ),
                      backgroundColor: Colors.transparent,
                      foregroundColor: kTealColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: const BorderSide(color: kTealColor),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'See Calendar',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              ?.copyWith(color: kTealColor),
                        ),
                        if (vm.displayWarning)
                          const Icon(
                            MdiIcons.alertCircle,
                            color: kPinkColor,
                            size: 20.0,
                          )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: AppButton.filled(
                    text: 'Apply',
                    onPressed: () async => performFuture<void>(
                      () async => vm.onSubmitHandler(),
                    ),
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
