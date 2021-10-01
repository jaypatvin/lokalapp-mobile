import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../../models/order.dart';
import '../../../utils/constants.dart';
import '../../../utils/themes.dart';
import '../../../widgets/app_button.dart';
import '../components/order_details_buttons/message_buttons.dart';
import '../components/transaction_details.dart';

class OrderReceived extends StatelessWidget {
  final Order order;
  const OrderReceived({Key key, @required this.order}) : super(key: key);
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
          SizedBox(
            width: double.infinity,
            child: AppButton("Rate your experience", kTealColor, true, null),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 90.0,
            ),
            Text(
              "Order Received!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontFamily: "GoldplayBold",
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
            SizedBox(
              height: 20,
            ),
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
                      kAnimationOk,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TransactionDetails(
                transaction: this.order,
                isBuyer: true,
              ),
            ),
            SizedBox(
              height: 36.0,
            ),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }
}
