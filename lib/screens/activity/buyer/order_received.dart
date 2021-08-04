import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lokalapp/models/order.dart';
import 'package:lokalapp/screens/activity/components/order_details_buttons/order_button.dart';
import 'package:lokalapp/screens/activity/components/transaction_details.dart';
import 'package:lokalapp/utils/themes.dart';

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
          Row(
            children: [
              OrderButton("Message Shop", kTealColor, false, null),
            ],
          ),
          Row(
            children: [
              OrderButton("Rate your experience", kTealColor, true, null),
            ],
          ),
          Row(
            children: [
              OrderButton(
                "Back to Activity",
                kTealColor,
                true,
                () {
                  Navigator.pop(context);
                },
              ),
            ],
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
