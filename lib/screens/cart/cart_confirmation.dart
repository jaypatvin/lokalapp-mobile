import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ],
      ),
      body: ConstrainedScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0.w),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 140.0.h,
                width: double.infinity,
                child: Lottie.asset(kAnimationOk, fit: BoxFit.contain),
              ),
              SizedBox(height: 32.h),
              Text(
                isSubscription ? 'Subscription for Review!' : 'Order Placed!',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: kTealColor),
              ),
              const SizedBox(height: 16),
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
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      const TextSpan(text: ' page.'),
                    ],
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: AppButton.transparent(
                  text: 'BACK TO MY CART',
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
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: AppButton.filled(
                  text: 'GO TO MY ACTIVITY',
                  onPressed: () async {
                    AppRouter.discoverNavigatorKey.currentState
                        ?.popUntil(ModalRoute.withName(Discover.routeName));
                    context.read<AppRouter>().jumpToTab(AppRoute.activity);
                  },
                ),
              ),
              SizedBox(height: 10.0.h),
            ],
          ),
        ),
      ),
    );
  }
}
