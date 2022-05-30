import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../routers/app_router.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/overlays/constrained_scrollview.dart';
import '../discover/discover.dart';
import 'checkout_cart.dart';

class CartConfirmation extends StatelessWidget {
  static const routeName = '/cart/confirmation';
  final bool isSubscription;
  const CartConfirmation({
    Key? key,
    this.isSubscription = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF1FAFF),
      appBar: CustomAppBar(
        buildLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () {
              context
                  .read<AppRouter>()
                  .keyOf(AppRoute.discover)
                  .currentState!
                  .popUntil(ModalRoute.withName(Discover.routeName));
            },
            child: Text(
              'Done',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: kTealColor),
            ),
          ),
        ],
      ),
      body: ConstrainedScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              width: double.infinity,
              child: Lottie.asset(kAnimationOk, fit: BoxFit.contain),
            ),
            const SizedBox(height: 30),
            Text(
              isSubscription ? 'Subscription for Review!' : 'Order Placed!',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(color: kTealColor, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: isSubscription
                          ? 'You can check the status of '
                              'your subscription using the '
                          : 'You can track your order using the ',
                    ),
                    TextSpan(
                      text: 'My Activity',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const TextSpan(text: ' page.'),
                  ],
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontWeight: FontWeight.w400),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: AppButton.transparent(
                text: 'BACK TO MY CART',
                width: double.infinity,
                onPressed: () {
                  context
                      .read<AppRouter>()
                      .keyOf(AppRoute.discover)
                      .currentState!
                    ..popUntil(ModalRoute.withName(Discover.routeName))
                    ..pushNamed(CheckoutCart.routeName);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: AppButton.filled(
                text: 'GO TO MY ACTIVITY',
                width: double.infinity,
                onPressed: () async {
                  AppRouter.discoverNavigatorKey.currentState
                      ?.popUntil(ModalRoute.withName(Discover.routeName));
                  context.read<AppRouter>().jumpToTab(AppRoute.activity);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
