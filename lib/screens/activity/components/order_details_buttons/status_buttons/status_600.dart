import 'package:flutter/material.dart';

import '../../../../../models/order.dart';
import '../../../../../widgets/app_button.dart';
import '../message_buttons.dart';
import '../order_actions.dart';
import '../view_payment_button.dart';

class Status600Buttons extends StatelessWidget {
  final bool isBuyer;
  final Order order;
  final void Function(OrderAction) onPress;
  const Status600Buttons({
    Key? key,
    this.isBuyer = true,
    required this.order,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isBuyer) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (order.paymentMethod != PaymentMethod.cod)
            ViewPaymentButton(onPress: onPress),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: MessageSellerButton(order: order),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              Expanded(
                child: AppButton.filled(
                  text: 'Order Again',
                  onPressed: () => onPress(OrderAction.orderAgain),
                ),
              )
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        if (order.paymentMethod != PaymentMethod.cod)
          ViewPaymentButton(onPress: onPress),
        SizedBox(
          width: double.infinity,
          child: MessageBuyerButton(order: order),
        ),
      ],
    );
  }
}
