import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/product_subscription_plan.dart';
import '../../../providers/auth.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/hook.view.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/activity/subscriptions/subscription_plan.screen.vm.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/overlays/constrained_scrollview.dart';
import '../../../widgets/overlays/screen_loader.dart';
import 'components/subscription_plan.details.dart';

/// This Widget will display all states/conditions of the order details to avoid
/// code repetition.
class SubscriptionPlanScreen extends StatelessWidget {
  const SubscriptionPlanScreen({
    Key? key,
    required this.subscriptionPlan,
    this.isBuyer = true,
  }) : super(key: key);
  final bool isBuyer;
  final ProductSubscriptionPlan subscriptionPlan;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _SubscriptionDetailsView(),
      viewModel: SubscriptionPlanScreenViewModel(
        subscriptionPlan: subscriptionPlan,
        isBuyer: isBuyer,
      ),
    );
  }
}

class _SubscriptionDetailsView extends HookView<SubscriptionPlanScreenViewModel>
    with HookScreenLoader {
  @override
  Widget screen(BuildContext context, SubscriptionPlanScreenViewModel vm) {
    final _address = useMemoized<String>(() {
      final _address = context.read<Auth>().user!.address;
      final _addressList = [
        _address.street,
        _address.barangay,
        _address.subdivision,
        _address.city,
      ];

      return _addressList.where((text) => text.isNotEmpty).join(', ');
    });

    final _subHeader = useMemoized<String>(
      () {
        switch (vm.subscriptionPlan.status) {
          case SubscriptionStatus.enabled:
            return 'Active Subscriptions';
          case SubscriptionStatus.cancelled:
            return 'Declined Subscriptions';
          case SubscriptionStatus.unsubscribed:
            return 'Past Subscriptions';
          case SubscriptionStatus.disabled:
            return vm.isBuyer ? 'For Confirmation' : 'To Confirm';
        }
      },
      [vm, vm.isBuyer, vm.subscriptionPlan],
    );

    final _displayWarning = useMemoized<bool>(
      () {
        final status = vm.subscriptionPlan.status;
        return (status == SubscriptionStatus.enabled ||
                status == SubscriptionStatus.disabled) &&
            vm.isBuyer;
      },
      [vm, vm.subscriptionPlan, vm.isBuyer],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: vm.isBuyer ? kTealColor : const Color(0xFF57183F),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Order Details',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.white),
            ),
            Text(
              _subHeader,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      body: ConstrainedScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 37,
          ),
          child: Column(
            children: [
              SubscriptionPlanDetails(
                isBuyer: vm.isBuyer,
                displayHeader: false,
                subscriptionPlan: vm.subscriptionPlan,
              ),
              const Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Spacer(),
                  Text(
                    'Order Total\t',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(color: Colors.black),
                  ),
                  Text(
                    'P ${vm.orderTotal}',
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes:',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(color: Colors.black),
                    ),
                    Text(
                      vm.subscriptionPlan.instruction,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Delivery Address:',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(color: Colors.black),
                    ),
                    Text(
                      _address,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Spacer(),
              _SubscriptionDetailsButtons(
                isBuyer: vm.isBuyer,
                // let's check first if we're displaying the buyer screen
                // to avoid calling [vm.checkForConflicts] every rebuild.
                displayWarning: _displayWarning && vm.checkForConflicts(),
                status: vm.subscriptionPlan.status,
                onSeeSchedule: vm.onSeeSchedule,
                onMessageHandler: vm.onMessageSend,
                onSubscribeAgain: vm.onSubscribeAgain,
                onUnsubscribe: () async =>
                    performFuture<void>(vm.onUnsubscribe),
                onConfirmSubscription: () async =>
                    performFuture<void>(vm.onConfirmSubscription),
                onDeclineSubscription: () async =>
                    performFuture<void>(vm.onDeclineSubscription),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubscriptionDetailsButtons extends StatelessWidget {
  final bool isBuyer;
  final bool displayWarning;
  final SubscriptionStatus status;
  final void Function()? onSeeSchedule;
  final void Function()? onMessageHandler;
  final void Function()? onUnsubscribe;
  final void Function()? onSubscribeAgain;
  final void Function()? onConfirmSubscription;
  final void Function()? onDeclineSubscription;
  const _SubscriptionDetailsButtons({
    Key? key,
    this.isBuyer = true,
    this.displayWarning = false,
    this.status = SubscriptionStatus.disabled,
    this.onSeeSchedule,
    this.onMessageHandler,
    this.onUnsubscribe,
    this.onSubscribeAgain,
    this.onConfirmSubscription,
    this.onDeclineSubscription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _displaySellerButton = !isBuyer &&
        (status == SubscriptionStatus.disabled ||
            status == SubscriptionStatus.enabled);
    return Column(
      children: [
        if (status == SubscriptionStatus.enabled ||
            status == SubscriptionStatus.disabled)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(2.5),
            child: ElevatedButton(
              onPressed: onSeeSchedule,
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                elevation: 0.0,
                primary: Colors.transparent,
                minimumSize: const Size(0, 43),
                side: const BorderSide(color: kTealColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'See Schedule',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(color: kTealColor),
                  ),
                  if (displayWarning)
                    const Icon(
                      MdiIcons.alertCircle,
                      color: kPinkColor,
                      size: 20.0,
                    )
                ],
              ),
            ),
          ),
        Row(
          children: [
            if (isBuyer && status == SubscriptionStatus.enabled)
              Expanded(
                child: AppButton.transparent(
                  text: 'Unsubscribe',
                  color: kPinkColor,
                  onPressed: onUnsubscribe,
                ),
              )
            else if (isBuyer && status == SubscriptionStatus.unsubscribed)
              Expanded(
                child: AppButton.transparent(
                  text: 'Subscribe Again',
                  onPressed: onSubscribeAgain,
                ),
              ),
            Expanded(
              child: AppButton.transparent(
                text: isBuyer ? 'Message Seller' : 'Message Buyer',
                onPressed: onMessageHandler,
              ),
            )
          ],
        ),
        if (_displaySellerButton)
          Row(
            children: [
              if (status == SubscriptionStatus.disabled)
                Expanded(
                  child: AppButton.transparent(
                    text: 'Decline Subscription',
                    color: kPinkColor,
                    onPressed: onDeclineSubscription,
                  ),
                ),
              if (status == SubscriptionStatus.enabled)
                Expanded(
                  child: AppButton.transparent(
                    text: 'Cancel Subscription',
                    color: kPinkColor,
                    onPressed: onDeclineSubscription,
                  ),
                ),
              if (status == SubscriptionStatus.disabled)
                Expanded(
                  child: AppButton.filled(
                    text: 'Confirm Subscription',
                    onPressed: onConfirmSubscription,
                    color: kOrangeColor,
                  ),
                ),
            ],
          )
      ],
    );
  }
}
