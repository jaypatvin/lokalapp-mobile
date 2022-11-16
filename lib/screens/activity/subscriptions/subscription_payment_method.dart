import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../models/post_requests/product_subscription_plan/product_subscription_plan.request.dart';
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
    super.key,
    required this.request,
    required this.reschedule,
  });

  final ProductSubscriptionPlanRequest request;
  final bool reschedule;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _SubscriptionPaymentMethodView(),
      viewModel: SubscriptionPaymentMethodViewModel(
        request: request,
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
      appBar: const CustomAppBar(
        backgroundColor: Colors.transparent,
        titleText: 'Choose a Payment Option',
        leadingColor: kTealColor,
        titleStyle: TextStyle(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 175,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SvgPicture.asset(
                      kSvgBackgroundHouses,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'P${vm.totalPrice}',
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              ?.copyWith(fontSize: 44, color: kOrangeColor),
                        ),
                        Text(
                          'Total Payment',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PaymentOptionsWidget(
              onPaymentPressed: (mode) async => performFuture<void>(
                () async => vm.onSubmitHandler(mode),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
