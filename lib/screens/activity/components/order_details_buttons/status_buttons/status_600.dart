import 'package:flutter/material.dart';

import '../../../../../utils/themes.dart';
import '../message_buttons.dart';
import '../order_actions.dart';
import '../order_button.dart';
import '../view_payment_button.dart';

class Status600Buttons extends StatelessWidget {
  final bool isBuyer;
  final void Function(OrderAction) onPress;
  const Status600Buttons({
    Key key,
    this.isBuyer = true,
    @required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.isBuyer) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MessageSellerButton(),
            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
            OrderButton(
              "Order Again",
              kTealColor,
              true,
              () => this.onPress(OrderAction.orderAgain),
            )
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
            children: [
              MessageBuyerButton(),
            ],
          ),
        ],
      ),
    );
  }
}
