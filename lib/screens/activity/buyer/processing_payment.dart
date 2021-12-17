import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../../models/order.dart';
import '../../../routers/app_router.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';
import '../activity.dart';
import '../components/order_details_buttons/message_buttons.dart';
import '../components/transaction_details.dart';

enum PaymentMode { cash, bank, gCash }

extension PaymentModeExtension on PaymentMode {
  String get value {
    switch (this) {
      case PaymentMode.cash:
        return "cod";
      case PaymentMode.bank:
        return "bank";
      case PaymentMode.gCash:
        return "e-wallet";
      default:
        return "";
    }
  }
}

class ProcessingPayment extends StatelessWidget {
  final Order order;
  final PaymentMode paymentMode;

  const ProcessingPayment({
    Key? key,
    required this.order,
    required this.paymentMode,
  }) : super(key: key);

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
              SizedBox(height: 20.0.h),
              Text(
                _getTitleText(),
                style: Theme.of(context).textTheme.headline5?.copyWith(
                    color: Colors.black, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20.0.h),
              Container(
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
                  transaction: this.order,
                  isBuyer: true,
                ),
              ),
              SizedBox(height: 24.0.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 5.0.h),
                      child: MessageSellerButton(order: order),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        "Back to Activity",
                        kTealColor,
                        true,
                        () {
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
