import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../screens/activity/buyer/processing_payment.dart';
import '../utils/constants/themes.dart';

class PaymentOptions extends StatelessWidget {
  final void Function(PaymentMode) onPaymentPressed;
  final Color tileColor;

  const PaymentOptions({
    Key? key,
    required this.onPaymentPressed,
    this.tileColor = kInviteScreenColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: ListView(
        shrinkWrap: true,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(30.0.r)),
            child: ListTile(
              tileColor: this.tileColor,
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: SvgPicture.asset(
                  "assets/payment/cash.svg",
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                "Cash On Delivery",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: kTealColor,
                size: 18.0.r,
              ),
              onTap: () => this.onPaymentPressed(PaymentMode.cash),
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            child: ListTile(
              tileColor: this.tileColor,
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: SvgPicture.asset(
                  "assets/payment/bank.svg",
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                "Bank Transfer/Deposit",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: kTealColor,
                size: 18.0.r,
              ),
              onTap: () => this.onPaymentPressed(PaymentMode.bank),
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(30.0.r)),
            child: ListTile(
              tileColor: this.tileColor,
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: SvgPicture.asset(
                  "assets/payment/gcash.svg",
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                "Gcash",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: kTealColor,
                size: 18.0.r,
              ),
              onTap: () => this.onPaymentPressed(PaymentMode.gCash),
            ),
          ),
        ],
      ),
    );
  }
}
