import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../../models/order.dart';
import '../../../routers/app_router.dart';
import '../../../utils/constants/assets.dart';
import '../../../widgets/app_button.dart';
import '../activity.dart';
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
        child: Column(
          children: [
            SizedBox(height: 20.0.h),
            Text(
              'Payment Confirmed!',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 20.0.h),
            SizedBox(
              height: 100.0.h,
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
                      width: 250.w,
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
            SizedBox(height: 16.0.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0.w),
              child: TransactionDetails(
                transaction: order,
                isBuyer: false,
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
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
    );
  }
}
