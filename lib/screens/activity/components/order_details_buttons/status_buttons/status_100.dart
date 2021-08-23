import 'package:flutter/material.dart';

import '../../../../../models/order.dart';
import '../../../../../utils/themes.dart';
import '../../../../../widgets/app_button.dart';
import '../message_buttons.dart';
import '../order_actions.dart';

class Status100Buttons extends StatelessWidget {
  final bool isBuyer;
  final Order order;
  final void Function(OrderAction) onPress;
  const Status100Buttons({
    Key key,
    this.isBuyer = true,
    @required this.order,
    @required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.isBuyer) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppButton(
              "Cancel Order",
              kPinkColor,
              false,
              () => this.onPress(OrderAction.cancel),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
            MessageSellerButton(order: this.order),
          ],
        ),
      );
    }

    return Container(
      child: Column(
        children: [
          Row(
            children: [
              MessageBuyerButton(order: this.order),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton(
                "Decline Order",
                kPinkColor,
                false,
                () => this.onPress(OrderAction.decline),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              AppButton(
                "Confirm Order",
                kOrangeColor,
                true,
                () => this.onPress(OrderAction.confirm),
              )
            ],
          ),
        ],
      ),
    );
  }
}
