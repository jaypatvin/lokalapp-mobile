import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/product_subscription_plan.dart';
import '../../../providers/auth.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/hook.view.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/activity/subscriptions/subscription_details.vm.dart';
import '../../../widgets/app_button.dart';
import 'components/subscription_plan_details.dart';

// This Widget will display all states/conditions of the order details to avoid
// code repetition.
class SubscriptionDetails extends StatelessWidget {
  const SubscriptionDetails({
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
      viewModel: SubscriptionDetailsViewModel(
        subscriptionPlan: subscriptionPlan,
        isBuyer: isBuyer,
      ),
    );
  }
}

class _SubscriptionDetailsView extends HookView<SubscriptionDetailsViewModel> {
  @override
  Widget render(BuildContext context, SubscriptionDetailsViewModel vm) {
    final _address = useMemoized<String>(() {
      final _address = context.read<Auth>().user!.address!;
      final _addressList = [
        _address.street,
        _address.barangay,
        _address.subdivision,
        _address.city,
      ];

      return _addressList.where((text) => text.isNotEmpty).join(', ');
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: vm.isBuyer ? kTealColor : Color(0xFF57183F),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Order Details",
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Colors.white,
                  ),
            ),
            Text(
              "Subscription",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 36.0.w,
        ),
        child: Column(
          children: [
            SubscriptionPlanDetails(
              isBuyer: vm.isBuyer,
              displayHeader: false,
              subscriptionPlan: vm.subscriptionPlan,
            ),
            Divider(),
            Container(
              width: double.infinity,
              child: Align(
                alignment: Alignment.centerRight,
                child: RichText(
                  text: TextSpan(
                    text: 'Order Total\t',
                    children: [
                      TextSpan(
                        text: 'P ${vm.orderTotal}',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Colors.orange),
                      ),
                    ],
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0.h),
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Notes:",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    vm.subscriptionPlan.instruction!,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(height: 16.0.h),
                  Text(
                    "Delivery Address:",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    _address,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(height: 16.0.h),
                ],
              ),
            ),
            //SizedBox(height: 16.0.h),
            Spacer(),
            _SubscriptionDetailsButtons(
              isBuyer: vm.isBuyer,
              displayWarning: vm.checkForConflicts(),
              onSeeSchedule: vm.onSeeSchedule,
              onMessageHandler: vm.onMessageSend,
              onUnsubscribe: vm.onUnsubscribe,
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionDetailsButtons extends StatelessWidget {
  final bool isBuyer;
  final bool displayWarning;
  final void Function()? onSeeSchedule;
  final void Function()? onMessageHandler;
  final void Function()? onUnsubscribe;
  const _SubscriptionDetailsButtons({
    Key? key,
    required this.displayWarning,
    this.onSeeSchedule,
    this.onMessageHandler,
    this.onUnsubscribe,
    this.isBuyer = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: this.onSeeSchedule,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "See Schedule",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: kTealColor),
                ),
                if (displayWarning)
                  Icon(
                    MdiIcons.alertCircle,
                    color: kPinkColor,
                    size: 20.0.r,
                  )
              ],
            ),
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              elevation: 0.0,
              primary: Colors.transparent,
              minimumSize: Size(0, 40.0.h),
              side: BorderSide(color: kTealColor),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: AppButton(
                "Unsubscribe",
                kPinkColor,
                false,
                this.onUnsubscribe,
              ),
            ),
            SizedBox(width: 10.0.w),
            Expanded(
              child: AppButton(
                this.isBuyer ? "Message Seller" : "Message Buyer",
                kTealColor,
                false,
                this.onMessageHandler,
              ),
            )
          ],
        ),
      ],
    );
  }
}
