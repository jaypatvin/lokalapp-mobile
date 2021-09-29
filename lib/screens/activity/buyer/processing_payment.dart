import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../../models/order.dart';
import '../../../utils/constants.dart';
import '../../../utils/themes.dart';
import '../../../widgets/app_button.dart';
import '../components/order_details_buttons/message_buttons.dart';
import '../components/transaction_details.dart';

enum PaymentMode { cash, bank, gCash }

class ProcessingPayment extends StatelessWidget {
  final Order order;
  final PaymentMode paymentMode;

  const ProcessingPayment({
    Key key,
    @required this.order,
    @required this.paymentMode,
  }) : super(key: key);

  Widget _buildButtons(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: MessageSellerButton(order: order),
          ),
          Container(
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

  String _getTitleText() {
    switch (this.paymentMode) {
      case PaymentMode.bank:
        return "Processing Payment!";
      case PaymentMode.cash:
        return "Cash on Delivery!";
      case PaymentMode.gCash:
        return "GCash!";
      default:
        return "";
    }
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
                _getTitleText(),
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
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  "Please wait for the Shop to confirm your payment. "
                  "We will notify you once the payment has been confirmed.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TransactionDetails(
                  transaction: this.order,
                  isBuyer: true,
                ),
              ),
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
