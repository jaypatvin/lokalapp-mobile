import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../../app/app.locator.dart';
import '../../../app/app_router.dart';
import '../../../models/order.dart';
import '../../../utils/constants/assets.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/overlays/constrained_scrollview.dart';
import '../components/order_details_buttons/message_buttons.dart';
import '../components/transaction_details.dart';

class ProcessingPayment extends StatelessWidget {
  final Order order;
  final PaymentMethod paymentMode;

  const ProcessingPayment({
    Key? key,
    required this.order,
    required this.paymentMode,
  }) : super(key: key);

  String _getTitleText() {
    switch (paymentMode) {
      case PaymentMethod.bank:
        return 'Processing Payment!';
      case PaymentMethod.cod:
        return 'Cash on Delivery!';
      case PaymentMethod.eWallet:
        return 'E-Wallet!';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ConstrainedScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                _getTitleText(),
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
                child: Text(
                  'Please wait for the Shop to confirm your payment. '
                  'We will notify you once the payment has been confirmed.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 37),
                child: TransactionDetails(
                  transaction: order,
                  isBuyer: true,
                ),
              ),
              const SizedBox(height: 24),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: MessageSellerButton(order: order),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton.filled(
                        text: 'Back to Activity',
                        onPressed: () {
                          locator<AppRouter>().popUntil(AppRoute.activity);
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
