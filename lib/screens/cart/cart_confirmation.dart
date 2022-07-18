import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/app_router.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/overlays/constrained_scrollview.dart';

class CartConfirmation extends StatelessWidget {
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
              locator<AppRouter>().popUntil(
                AppRoute.discover,
                predicate: ModalRoute.withName(DashboardRoutes.discover),
              );
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
                  locator<AppRouter>()
                    ..popUntil(
                      AppRoute.discover,
                      predicate: ModalRoute.withName(DashboardRoutes.discover),
                    )
                    ..navigateTo(
                      AppRoute.discover,
                      DiscoverRoutes.checkoutCart,
                    );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: AppButton.filled(
                text: 'GO TO MY ACTIVITY',
                width: double.infinity,
                onPressed: () async {
                  locator<AppRouter>()
                    ..popUntil(
                      AppRoute.discover,
                      predicate: ModalRoute.withName(DashboardRoutes.discover),
                    )
                    ..jumpToTab(AppRoute.activity);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
