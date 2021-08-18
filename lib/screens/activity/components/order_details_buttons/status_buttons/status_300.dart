import 'package:flutter/material.dart';

import '../../../../../models/order.dart';
import '../../../../../utils/themes.dart';
import '../message_buttons.dart';
import '../order_actions.dart';
import '../order_button.dart';
import '../view_payment_button.dart';

class Status300Buttons extends StatelessWidget {
  final bool isBuyer;
  final Order order;
  final void Function(OrderAction) onPress;
  final String paymentMethod;
  const Status300Buttons({
    Key key,
    this.isBuyer = true,
    @required this.order,
    @required this.onPress,
    @required this.paymentMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.isBuyer) {
      return Container(
        child: Column(
          children: [
            Row(
              children: [
                ViewPaymentButton(onPress: this.onPress),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Row(
              children: [
                MessageSellerButton(order: this.order),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      child: Column(
        children: [
          if (this.paymentMethod != "cod")
            Row(
              children: [
                ViewPaymentButton(onPress: this.onPress),
              ],
            ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MessageBuyerButton(order: this.order),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              OrderButton(
                "Confirm Payment",
                kOrangeColor,
                true,
                () => this.onPress(OrderAction.confirmPayment),
              )
            ],
          ),
        ],
      ),
    );
  }
}
