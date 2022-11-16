import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../models/app_navigator.dart';
import '../../../models/product_subscription_plan.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/hook.view.dart';
import '../../../view_models/activity/subscriptions/seller_subscription_schedule.vm.dart';
import '../../../view_models/activity/subscriptions/subscription_schedule.vm.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/overlays/constrained_scrollview.dart';
import '../../../widgets/schedule_picker.dart';
import '../../discover/product_detail.dart';
import 'components/buyer_subscription_schedule.view.dart';
import 'components/seller_subscription_schedule.view.dart';
import 'subscription_schedule/subscription_schedule.product_card.dart';

class SubscriptionSchedule extends StatelessWidget {
  const SubscriptionSchedule._({
    super.key,
    required this.child,
  });

  factory SubscriptionSchedule.seller({
    Key? key,
    required ProductSubscriptionPlan subscriptionPlan,
  }) {
    return SubscriptionSchedule._(
      key: key,
      child: MVVM(
        view: (_, __) => SellerSubscriptionScheduleView(),
        viewModel: SellerSubscriptionScheduleViewModel(
          subscriptionPlan: subscriptionPlan,
        ),
      ),
    );
  }

  factory SubscriptionSchedule.view({
    Key? key,
    required ProductSubscriptionPlan subscriptionPlan,
  }) {
    return SubscriptionSchedule._(
      key: key,
      child: MVVM(
        view: (_, __) => BuyerSubscriptionScheduleView(),
        viewModel: ViewSubscriptionScheduleViewModel(
          subscriptionPlan: subscriptionPlan,
        ),
      ),
    );
  }

  factory SubscriptionSchedule.create({
    Key? key,
    required String productId,
  }) {
    return SubscriptionSchedule._(
      key: key,
      child: MVVM(
        view: (_, __) => _NewSubscriptionScheduleView(),
        viewModel: NewSubscriptionScheduleViewModel(
          productId: productId,
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
    extends HookView<NewSubscriptionScheduleViewModel> {
  @override
  Widget render(
    BuildContext context,
    NewSubscriptionScheduleViewModel vm,
  ) {
    final repeatUnitFocusNode = useFocusNode();

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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                const SizedBox(height: 24),
                SchedulePicker(
                  header: 'Schedule',
                  description: 'Which dates do you want this product '
                      'to be delivered?',
                  repeatUnitFocusNode: repeatUnitFocusNode,
                  onRepeatTypeChanged: vm.onRepeatTypeChanged,
                  onStartDatesChanged: vm.onStartDatesChanged,
                  onRepeatUnitChanged: vm.onRepeatUnitChanged,
                  onSelectableDaysChanged: vm.onSelectableDaysChanged,
                  // repeatabilityChoices: vm.repeatabilityChoices,
                  operatingHours: vm.operatingHours,
                  limitSelectableDates: true,
                ),
                const SizedBox(height: 24),
                Visibility(
                  visible: vm.displayWarning,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        MdiIcons.alertCircle,
                        color: Colors.red,
                        size: 30,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'There will be days on the schedule that you set that '
                          "this shop won't be able to deliver. You will be "
                          'notified when you receive the order prior those orders '
                          "and you'll be able to re-schedule it or else it won't "
                          'be placed.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: AppButton.filled(
                    text: 'Next',
                    onPressed: vm.onSubmitHandler,
                  ),
                ),
                const SizedBox(height: 21),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
