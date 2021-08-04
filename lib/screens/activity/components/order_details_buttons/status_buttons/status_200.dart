import 'package:flutter/material.dart';

import '../../../../../utils/themes.dart';
import '../message_buttons.dart';
import '../order_actions.dart';
import '../order_button.dart';

class Status200Buttons extends StatelessWidget {
  final bool isBuyer;
  final void Function(OrderAction) onPress;
  const Status200Buttons({
    Key key,
    this.isBuyer = true,
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
                MessageSellerButton(),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OrderButton(
                  "Cancel Order",
                  kPinkColor,
                  false,
                  () => this.onPress(OrderAction.cancel),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                OrderButton(
                  "Pay Now",
                  kOrangeColor,
                  true,
                  () => this.onPress(OrderAction.pay),
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
          Row(
            children: [
              MessageBuyerButton(),
            ],
          ),
        ],
      ),
    );
  }
}
