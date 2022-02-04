import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/app_navigator.dart';
import '../../../models/order.dart';
import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';
import '../order_details.dart';
import 'transaction_details.dart';

class TransactionCard extends StatelessWidget {
  factory TransactionCard({
    required Order order,
    String? status,
    bool isBuyer = false,
    void Function()? onSecondButtonPress,
  }) {
    bool enableSecondButton = false;
    String secondButtonText = '';

    switch (order.statusCode) {
      case 10:
      case 20:
        enableSecondButton = true;
        secondButtonText = 'Message ${isBuyer ? 'Seller' : 'Buyer'}';
        break;
      case 100:
        enableSecondButton = !isBuyer;
        secondButtonText = 'Confirm Order';
        break;
      case 200:
        enableSecondButton = isBuyer;
        secondButtonText = 'Pay Now';
        break;
      case 300:
        enableSecondButton = !isBuyer;
        secondButtonText = 'Confirm Payment';
        break;
      case 400:
        enableSecondButton = !isBuyer;
        secondButtonText = 'Ship Out';
        break;
      case 500:
        enableSecondButton = isBuyer;
        secondButtonText = 'Order Received';
        break;
      case 600:
        enableSecondButton = true;
        secondButtonText = isBuyer ? 'Order Again' : 'Delivered';
        break;
      default:
        break;
    }

    double price = 0;

    for (final product in order.products) {
      price += product.price * product.quantity;
    }

    return TransactionCard._(
      order,
      enableSecondButton,
      secondButtonText,
      price,
      status,
      isBuyer,
      onSecondButtonPress,
    );
  }
  final Order order;
  final bool enableSecondButton;
  final String secondButtonText;
  final double price;
  final String? status;
  final bool isBuyer;
  final void Function()? onSecondButtonPress;

  const TransactionCard._(
    this.order,
    this.enableSecondButton,
    this.secondButtonText,
    this.price,
    this.status,
    this.isBuyer,
    this.onSecondButtonPress,
  );

  // We'll let this Stateless Widget handle the generation of
  // its second button. If performance is an issue, we can probably
  // lift it one state up.

  Widget buildActionButtons(BuildContext context) {
    var secondButtonColor = kOrangeColor;
    if (order.statusCode == 10 || order.statusCode == 20) {
      secondButtonColor = kTealColor;
    } else if (order.statusCode == 600) {
      secondButtonColor = Colors.grey;
    }

    final disabled = order.statusCode == 600 && !isBuyer;
    final isFilled = (order.statusCode != 10) && (order.statusCode != 20);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AppButton.transparent(
            text: 'Details',
            onPressed: () => Navigator.push(
              context,
              AppNavigator.appPageRoute(
                builder: (_) => OrderDetails(
                  order: order,
                  isBuyer: isBuyer,
                  subheader: status ?? '',
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: enableSecondButton,
          child: SizedBox(width: 5.0.w),
        ),
        Visibility(
          visible: enableSecondButton,
          child: Expanded(
            child: AppButton.custom(
              text: secondButtonText,
              color: secondButtonColor,
              isFilled: isFilled,
              onPressed: disabled ? null : onSecondButtonPress,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0.r),
        side: (order.statusCode == 10 || order.statusCode == 20)
            ? const BorderSide(color: Colors.red)
            : BorderSide.none,
      ),
      color: const Color(0xFFF1FAFF),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 15.0.h),
        child: Column(
          children: [
            TransactionDetails(
              status: status,
              transaction: order,
              isBuyer: isBuyer,
            ),
            SizedBox(height: 15.0.h),
            buildActionButtons(context),
          ],
        ),
      ),
    );
  }
}
