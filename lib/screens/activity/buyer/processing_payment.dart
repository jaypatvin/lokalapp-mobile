import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../../models/order.dart';
import '../../../routers/app_router.dart';
import '../../../utils/constants/assets.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/overlays/constrained_scrollview.dart';
import '../activity.dart';
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
              SizedBox(height: 20.0.h),
              Text(
                _getTitleText(),
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
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
                padding: EdgeInsets.symmetric(horizontal: 36.0.w),
                child: Text(
                  'Please wait for the Shop to confirm your payment. '
                  'We will notify you once the payment has been confirmed.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              SizedBox(height: 16.0.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                child: TransactionDetails(
                  transaction: order,
                  isBuyer: true,
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 5.0.h),
                      child: MessageSellerButton(order: order),
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
      ),
    );
  }
}
