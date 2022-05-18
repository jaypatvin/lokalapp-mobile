import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../../models/order.dart';
import '../../../routers/app_router.dart';
import '../../../utils/constants/assets.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/overlays/constrained_scrollview.dart';
import '../activity.dart';
import '../components/order_details_buttons/message_buttons.dart';
import '../components/transaction_details.dart';

class ShippedOut extends StatelessWidget {
  final Order order;

  const ShippedOut({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ConstrainedScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                'Order Shipped Out!',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 175,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SvgPicture.asset(
                        kSvgBackgroundHouses,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Lottie.asset(
                        kAnimationShippedOut,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 37),
                child: TransactionDetails(
                  transaction: order,
                  isBuyer: false,
                ),
              ),
              const SizedBox(height: 24),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 37),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: MessageBuyerButton(order: order),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton.filled(
                        text: 'Back to Activity',
                        onPressed: () {
                          AppRouter.activityNavigatorKey.currentState?.popUntil(
                            ModalRoute.withName(Activity.routeName),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
