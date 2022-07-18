import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../app/app_router.dart';
import '../../../models/order.dart';
import '../../../utils/constants/assets.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/overlays/constrained_scrollview.dart';
import '../components/order_details_buttons/message_buttons.dart';
import '../components/transaction_details.dart';

class PaymentConfirmed extends StatelessWidget {
  final Order order;

  const PaymentConfirmed({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ConstrainedScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                'Payment Confirmed!',
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
                    Center(
                      child: SizedBox(
                        width: 250,
                        child: Lottie.asset(
                          kAnimationPaymentReceived,
                          fit: BoxFit.scaleDown,
                          repeat: true,
                        ),
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
              const SizedBox(height: 24.0),
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
                          locator<AppRouter>().popUntil(
                            AppRoute.activity,
                            predicate:
                                ModalRoute.withName(DashboardRoutes.activity),
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
