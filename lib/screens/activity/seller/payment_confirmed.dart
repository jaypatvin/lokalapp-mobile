import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../../models/order.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';
import '../components/order_details_buttons/message_buttons.dart';
import '../components/transaction_details.dart';

class PaymentConfirmed extends StatelessWidget {
  final Order? order;

  const PaymentConfirmed({Key? key, this.order}) : super(key: key);

  Widget _buildButtons(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: MessageBuyerButton(order: order),
          ),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              "Back to Activity",
              kTealColor,
              true,
              () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.0),
              Text(
                "Payment Confirmed!",
                style: TextStyle(
                  fontFamily: "Goldplay",
                  fontWeight: FontWeight.w600,
                  fontSize: 24.0,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 140.0,
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
                        kAnimationPaymentReceived,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TransactionDetails(
                  transaction: this.order,
                  isBuyer: false,
                ),
              ),
              // Spacer(),
              SizedBox(height: 24.0),
              _buildButtons(context),
              SizedBox(height: 24.0)
            ],
          ),
        ),
      ),
    );
  }
}
