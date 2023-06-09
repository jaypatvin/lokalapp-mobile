import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../models/order.dart';
import '../../../utils/themes.dart';
import '../../../widgets/app_button.dart';
import '../components/transaction_details.dart';

class OrderConfirmed extends StatelessWidget {
  final Order order;
  final bool isBuyer;

  const OrderConfirmed({
    @required this.order,
    this.isBuyer = true,
  });

  Widget _buildButtons(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            child: AppButton("Message Buyer", kTealColor, false, null),
          ),
          Container(
            width: double.infinity,
            child: AppButton(
              "Back to Activity",
              kTealColor,
              true,
              () => Navigator.pop(context),
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
              "Order Confirmed!",
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
                      "assets/houses_background.svg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: SvgPicture.asset(
                      "assets/check_icon.svg",
                      fit: BoxFit.fitHeight,
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
                isBuyer: this.isBuyer,
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }
}
