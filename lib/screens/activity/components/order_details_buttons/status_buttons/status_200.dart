import 'package:flutter/material.dart';

import '../../../../../models/order.dart';
import '../../../../../utils/constants/themes.dart';
import '../../../../../widgets/app_button.dart';
import '../message_buttons.dart';
import '../order_actions.dart';

class Status200Buttons extends StatelessWidget {
  final bool isBuyer;
  final Order order;
  final void Function(OrderAction) onPress;
  const Status200Buttons({
    Key? key,
    this.isBuyer = true,
    required this.order,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isBuyer) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: MessageSellerButton(order: order),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: AppButton.transparent(
                  text: 'Cancel Order',
                  color: kPinkColor,
                  onPressed: () => onPress(OrderAction.cancel),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              Expanded(
                child: AppButton.filled(
                  text: 'Pay Now',
                  color: kOrangeColor,
                  onPressed: () => onPress(OrderAction.pay),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: MessageBuyerButton(order: order),
    );
  }
}
