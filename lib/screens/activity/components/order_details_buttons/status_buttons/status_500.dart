import 'package:flutter/material.dart';

import '../../../../../models/order.dart';
import '../../../../../utils/themes.dart';
import '../../../../../widgets/app_button.dart';
import '../message_buttons.dart';
import '../order_actions.dart';
import '../view_payment_button.dart';

class Status500Buttons extends StatelessWidget {
  final bool isBuyer;
  final Order order;
  final void Function(OrderAction) onPress;
  const Status500Buttons({
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
            Container(
              width: double.infinity,
              child: ViewPaymentButton(onPress: this.onPress),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: MessageSellerButton(order: this.order),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                Expanded(
                  child: AppButton(
                    "Order Received",
                    kOrangeColor,
                    true,
                    () => this.onPress(OrderAction.received),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: ViewPaymentButton(onPress: this.onPress),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Container(
            width: double.infinity,
            child: MessageBuyerButton(order: this.order),
          ),
        ],
      ),
    );
  }
}
