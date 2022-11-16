import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/hook.view.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/activity/subscriptions/subscriptions.buyer.vm.dart';
import '../../../view_models/activity/subscriptions/subscriptions.seller.vm.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import 'components/subscription_plan.stream.dart';

class Subscriptions extends StatelessWidget {
  static const routeName = '/activity/subscriptions';
  const Subscriptions({super.key, required this.isBuyer});
  final bool isBuyer;

  @override
  Widget build(BuildContext context) {
    if (isBuyer) {
      return MVVM<SubscriptionsBuyerViewModel>(
        view: (_, __) => _SubscriptionsBuyerView(),
        viewModel: SubscriptionsBuyerViewModel(),
      );
    }

    return MVVM<SubscriptionsSellerViewModel>(
      view: (_, __) => _SubscriptionsSellerView(),
      viewModel: SubscriptionsSellerViewModel(),
    );
  }
}

class _SubscriptionsBuyerView extends HookView<SubscriptionsBuyerViewModel> {
  @override
  Widget render(BuildContext context, SubscriptionsBuyerViewModel vm) {
    useAutomaticKeepAlive();
    return Scaffold(
      appBar: const CustomAppBar(
        titleText: 'My Subscriptions',
        titleStyle: TextStyle(color: Colors.white),
        backgroundColor: kTealColor,
      ),
      body: SubscriptionPlanStream(
        stream: vm.subscriptionPlanStream,
        onDetailsPressed: vm.onDetailsPressed,
      ),
    );
  }
}

class _SubscriptionsSellerView extends HookView<SubscriptionsSellerViewModel> {
  @override
  Widget render(BuildContext context, SubscriptionsSellerViewModel vm) {
    useAutomaticKeepAlive();
    return Scaffold(
      appBar: const CustomAppBar(
        titleText: 'Subscribers',
        titleStyle: TextStyle(color: Colors.white),
      ),
      body: vm.subscriptionPlanStream != null
          ? SubscriptionPlanStream(
              stream: vm.subscriptionPlanStream!,
              onDetailsPressed: vm.onDetailsPressed,
              onConfirmSubscription: vm.onConfirm,
              isBuyer: false,
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You have not created a shop yet!',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(height: 5),
                  AppButton.transparent(
                    text: 'Create Shop',
                    color: kPurpleColor,
                    onPressed: vm.createShopHandler,
                  ),
                ],
              ),
            ),
    );
  }
}
