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
import '../../../models/product_subscription_plan.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../view_models/activity/subscriptions/subscription_schedule.vm.dart';
import 'subscription_schedule/subscription_schedule.calendar.dart';
import 'subscription_schedule/subscription_schedule.product_card.dart';

class SubscriptionScheduleBuyer extends StatelessWidget {
  const SubscriptionScheduleBuyer({Key? key, required this.subscriptionPlan})
      : super(key: key);
  final ProductSubscriptionPlan subscriptionPlan;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _SubscriptionScheduleBuyerView(),
      viewModel: ViewSubscriptionScheduleViewModel(
        subscriptionPlan: subscriptionPlan,
      ),
    );
  }
}

class _SubscriptionScheduleBuyerView
    extends HookView<ViewSubscriptionScheduleViewModel> with HookScreenLoader {
  @override
  Widget screen(
    BuildContext context,
    ViewSubscriptionScheduleViewModel vm,
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
                bool _displayWarning = vm.displayWarning;
                return SubscriptionScheduleCalendar(
                  selectedDate: _selectedDate.value,
                  selectableDates: vm.productSelectableDates,
                  onDayPressed: (date) {
                    setState(() => vm.onDayPressedHandler(date));
                    if (_displayWarning != vm.displayWarning) {
                      setState(() => _displayWarning = vm.displayWarning);
                    }
                    _onDayPressed(date);
                  },
                  onNonSelectableDayPressed: (date) {
                    setState(() => vm.onNonSelectableDayPressedHandler(date));
                    _onDayPressed(date);
                  },
                  markedDates: vm.markedDates,
                  displayWarning: _displayWarning,
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
                  repeatUnitFocusNode: _repeatUnitFocusNode,
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
                    onPressed: () => _displayCalendar(),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(
                        double.infinity,
                        43,
                      ),
                      backgroundColor: Colors.transparent,
                      primary: kTealColor,
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
