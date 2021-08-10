import 'package:flutter/material.dart';

import '../../../../../models/order.dart';
import '../../../../../utils/themes.dart';
import '../message_buttons.dart';
import '../order_actions.dart';
import '../order_button.dart';
import '../view_payment_button.dart';

class Status400Buttons extends StatelessWidget {
  final bool isBuyer;
  final Order order;
  final void Function(OrderAction) onPress;
  const Status400Buttons({
    Key key,
    this.isBuyer = true,
    @required this.order,
    @required this.onPress,
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
                MessageSellerButton(),
              ],
            ),
          ],
        ),
      );
    }

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MessageBuyerButton(order: this.order),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              OrderButton(
                "Ship Out",
                kOrangeColor,
                true,
                () => this.onPress(OrderAction.shipOut),
              )
            ],
          ),
        ],
      ),
    );
  }
}
