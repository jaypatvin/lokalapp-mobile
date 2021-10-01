import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';
import '../../utils/themes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../discover/discover.dart';
import 'checkout_cart.dart';

class OrderPlaced extends StatelessWidget {
  static const routeName = "/cart/orderPlaced";
  const OrderPlaced({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0XFFF1FAFF),
      appBar: CustomAppBar(
        buildLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () => Navigator.popUntil(
              context,
              ModalRoute.withName(Discover.routeName),
            ),
            child: Text(
              "Done",
              style: TextStyle(
                color: kTealColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: "GoldPlay",
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 140.0,
              width: double.infinity,
              child: Lottie.asset(
                kAnimationOk,
              ),
            ),
            SizedBox(height: 32),
            Text(
              "Order Placed!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kTealColor,
                fontFamily: "GoldplayBold",
                fontWeight: FontWeight.bold,
                fontSize: 36.0,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "You can track your order using the "),
                    TextSpan(
                      text: "My Activity",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    TextSpan(text: " page."),
                  ],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: AppButton(
                    "BACK TO MY CART",
                    kTealColor,
                    false,
                    () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => CheckoutCart(),
                      ),
                      ModalRoute.withName(Discover.routeName),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: AppButton(
                    "GO TO MY ACTIVITY",
                    kTealColor,
                    true,
                    () {
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(Discover.routeName),
                      );
                      context.read<PersistentTabController>().jumpToTab(3);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
