import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../providers/subscriptions.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/hook.view.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/activity/subscriptions/subscription_payment_method.vm.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/overlays/screen_loader.dart';
import '../../../widgets/payment_options.widget.dart';

class SubscriptionPaymentMethod extends StatelessWidget {
  const SubscriptionPaymentMethod({
    Key? key,
    required this.subscriptionPlanBody,
    required this.reschedule,
  }) : super(key: key);

  final SubscriptionPlanBody subscriptionPlanBody;
  final bool reschedule;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _SubscriptionPaymentMethodView(),
      viewModel: SubscriptionPaymentMethodViewModel(
        subscriptionPlanBody: subscriptionPlanBody,
        reschedule: reschedule,
      ),
    );
  }
}

class _SubscriptionPaymentMethodView
    extends HookView<SubscriptionPaymentMethodViewModel> with HookScreenLoader {
  @override
  Widget screen(BuildContext context, SubscriptionPaymentMethodViewModel vm) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        backgroundColor: Colors.transparent,
        titleText: 'Choose a Payment Option',
        leadingColor: kTealColor,
        titleStyle: TextStyle(color: Colors.black),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 180.0.h,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SvgPicture.asset(
                      kSvgBackgroundHouses,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'P${vm.totalPrice}',
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              ?.copyWith(color: kOrangeColor),
                        ),
                        Text(
                          'Total Payment',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0.h),
            PaymentOptionsWidget(
              onPaymentPressed: (mode) async => performFuture<void>(
                () async => await vm.onSubmitHandler(mode),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
