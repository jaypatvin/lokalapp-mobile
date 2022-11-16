import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/order.dart';
import '../utils/constants/themes.dart';

class PaymentOptionsWidget extends StatelessWidget {
  const PaymentOptionsWidget({
    super.key,
    required this.onPaymentPressed,
    this.cashEnabled = true,
    this.bankEnabled = true,
    this.walletEnabled = true,
    this.tileColor = kInviteScreenColor,
  });

  final void Function(PaymentMethod paymentMethod) onPaymentPressed;
  final bool cashEnabled;
  final bool bankEnabled;
  final bool walletEnabled;
  final Color tileColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ListTile(
            enabled: cashEnabled,
            tileColor: tileColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              maxRadius: 16,
              child: SvgPicture.asset(
                'assets/payment/cash.svg',
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              'Cash On Delivery',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  ?.copyWith(color: Colors.black),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: kTealColor,
              size: 14,
            ),
            onTap: () => onPaymentPressed(PaymentMethod.cod),
          ),
          const SizedBox(height: 12),
          ListTile(
            enabled: bankEnabled,
            tileColor: bankEnabled ? tileColor : Colors.grey.shade200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              maxRadius: 16,
              child: SvgPicture.asset(
                'assets/payment/bank.svg',
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              'Bank Transfer/Deposit',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  ?.copyWith(color: Colors.black),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: bankEnabled ? kTealColor : Colors.grey.shade200,
              size: 14,
            ),
            onTap: () => onPaymentPressed(PaymentMethod.bank),
          ),
          const SizedBox(height: 12),
          ListTile(
            enabled: walletEnabled,
            tileColor: walletEnabled ? tileColor : Colors.grey.shade200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              maxRadius: 16,
              child: SvgPicture.asset(
                'assets/payment/gcash.svg',
              ),
            ),
            title: Text(
              'Gcash',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  ?.copyWith(color: Colors.black),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: walletEnabled ? kTealColor : Colors.grey.shade200,
              size: 14,
            ),
            onTap: () => onPaymentPressed(PaymentMethod.eWallet),
          ),
        ],
      ),
    );
  }
}
