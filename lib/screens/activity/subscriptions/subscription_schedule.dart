import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../models/app_navigator.dart';
import '../../../models/product_subscription_plan.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/hook.view.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/activity/subscriptions/subscription_schedule.vm.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/overlays/screen_loader.dart';
import '../../../widgets/schedule_picker.dart';
import '../../discover/product_detail.dart';
import 'subscription_schedule/subscription_schedule.calendar.dart';
import 'subscription_schedule/subscription_schedule.conflict.dart';
import 'subscription_schedule/subscription_schedule.product_card.dart';

class SubscriptionSchedule extends StatelessWidget {
  const SubscriptionSchedule._({
    Key? key,
    required this.child,
  }) : super(key: key);

  factory SubscriptionSchedule.view({
    required ProductSubscriptionPlan subscriptionPlan,
  }) {
    return SubscriptionSchedule._(
      child: MVVM(
        view: (_, __) => _ViewSubscriptionScheduleView(),
        viewModel: ViewSubscriptionScheduleViewModel(
          subscriptionPlan: subscriptionPlan,
        ),
      ),
    );
  }

  factory SubscriptionSchedule.create({
    required String productId,
  }) {
    // The notification to display when there are conflicts.
    Future<bool?> _displayNotification(BuildContext context) async {
      return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return ScheduleConflictsNotification(
            onAutomatic: () => Navigator.pop(ctx, true),
            onManual: () => Navigator.pop(ctx, false),
          );
        },
      );
    }

    return SubscriptionSchedule._(
      child: MVVM(
        view: (_, __) => _NewSubscriptionScheduleView(),
        viewModel: NewSubscriptionScheduleViewModel(
          productId: productId,
          displayNotification: _displayNotification,
        ),
      ),
    );
  }

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class _NewSubscriptionScheduleView
    extends HookView<NewSubscriptionScheduleViewModel> with HookScreenLoader {
  @override
  Widget screen(
    BuildContext context,
    NewSubscriptionScheduleViewModel vm,
  ) {
    final _repeatUnitFocusNode = useFocusNode();

    return Scaffold(
      appBar: const CustomAppBar(
        titleText: 'Subscription Schedule',
        titleStyle: TextStyle(color: Colors.black),
        leadingColor: Colors.black,
        backgroundColor: Colors.transparent,
      ),
      body: KeyboardActions(
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
                onEditTap: () => Navigator.push(
                  context,
                  AppNavigator.appPageRoute(
                    builder: (_) => ProductDetail(vm.product),
                  ),
                ),
              ),
              SizedBox(height: 10.0.h),
              SchedulePicker(
                header: 'Schedule',
                description: 'Which dates do you want this product '
                    'to be delivered?',
                repeatUnitFocusNode: _repeatUnitFocusNode,
                onRepeatTypeChanged: vm.onRepeatTypeChanged,
                onStartDatesChanged: vm.onStartDatesChanged,
                onRepeatUnitChanged: vm.onRepeatUnitChanged,
                onSelectableDaysChanged: vm.onSelectableDaysChanged,
                repeatabilityChoices: vm.repeatabilityChoices,
                operatingHours: vm.operatingHours,
                limitSelectableDates: true,
              ),
              SizedBox(height: 10.0.h),
              SizedBox(
                width: double.infinity,
                child: AppButton.filled(
                  text: 'Next',
                  onPressed: () async => performFuture<void>(
                    () async => vm.onSubmitHandler(),
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

class _ViewSubscriptionScheduleView
    extends HookView<ViewSubscriptionScheduleViewModel> with HookScreenLoader {
  @override
  Widget screen(
    BuildContext context,
    ViewSubscriptionScheduleViewModel vm,
  ) {
    final _repeatUnitFocusNode = useFocusNode();

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
                  selectableDates: vm.productSelectableDates,
                  onDayPressed: (date) {
                    vm.onDayPressedHandler(date);
                    if (_displayWarning != vm.displayWarning) {
                      setState(() => _displayWarning = vm.displayWarning);
                    }
                  },
                  onNonSelectableDayPressed:
                      vm.onNonSelectableDayPressedHandler,
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
      [vm],
    );

    return Scaffold(
      appBar: const CustomAppBar(
        titleText: 'Subscription Schedule',
        titleStyle: TextStyle(color: Colors.black),
        leadingColor: Colors.black,
        backgroundColor: Colors.transparent,
      ),
      body: KeyboardActions(
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
                description: 'Which dates do you want this product '
                    'to be delivered?',
                repeatUnitFocusNode: _repeatUnitFocusNode,
                onRepeatTypeChanged: vm.onRepeatTypeChanged,
                onStartDatesChanged: (_, __) {},
                onRepeatUnitChanged: vm.onRepeatUnitChanged,
                onSelectableDaysChanged: (_) {},
                repeatabilityChoices: vm.repeatabilityChoices,
                operatingHours: vm.operatingHours,
                editable: false,
              ),
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
                        "This shop won't be able to deliver on the date/s "
                        'you set. Please manually re-schedule these orders '
                        "or else they won't be placed.",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    )
                  ],
                ),
              if (vm.displayWarning) SizedBox(height: 20.0.h),
              TextButton(
                onPressed: () => _displayCalendar(),
                style: TextButton.styleFrom(
                  minimumSize: Size(double.infinity, 50.0.h),
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
                height: 50.0.h,
                width: double.infinity,
                child: AppButton.filled(
                  text: 'Apply',
                  onPressed: () async => performFuture<void>(
                    () async => vm.onSubmitHandler(),
                  ),
                  textStyle: TextStyle(fontSize: 20.0.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
