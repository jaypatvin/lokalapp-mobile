import 'package:flutter/material.dart';

import '../../../../../models/order.dart';
import '../../../../../utils/constants/themes.dart';
import '../../../../../widgets/app_button.dart';
import '../message_buttons.dart';
import '../order_actions.dart';
import '../view_payment_button.dart';

class Status400Buttons extends StatelessWidget {
  final bool isBuyer;
  final Order order;
  final void Function(OrderAction) onPress;
  const Status400Buttons({
    super.key,
    this.isBuyer = true,
    required this.order,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    if (isBuyer) {
      return Column(
        children: [
          if (order.paymentMethod != PaymentMethod.cod)
            ViewPaymentButton(onPress: onPress),
          SizedBox(
            width: double.infinity,
            child: MessageSellerButton(order: order),
          ),
        ],
      );
    }

    return Column(
      children: [
        if (order.paymentMethod != PaymentMethod.cod)
          ViewPaymentButton(onPress: onPress),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: MessageBuyerButton(order: order),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
            Expanded(
              child: AppButton.filled(
                text: 'Ship Out',
                color: kOrangeColor,
                onPressed: () => onPress(OrderAction.shipOut),
              ),
            )
          ],
        ),
      ],
    );
  }
}
