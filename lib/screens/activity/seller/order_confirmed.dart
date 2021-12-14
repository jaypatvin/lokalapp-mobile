import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../../models/order.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';
import '../components/order_details_buttons/message_buttons.dart';
import '../components/transaction_details.dart';

class OrderConfirmed extends StatelessWidget {
  final Order order;
  final bool isBuyer;

  const OrderConfirmed({
    required this.order,
    this.isBuyer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 90.0.h),
            Text(
              "Order Confirmed!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
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
                      kAnimationConfirmation,
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
                isBuyer: this.isBuyer,
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Padding(
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
                      () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
