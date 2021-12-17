import 'package:flutter/material.dart';

import '../../../../../models/order.dart';
import '../../../../../utils/constants/themes.dart';
import '../../../../../widgets/app_button.dart';
import '../message_buttons.dart';
import '../order_actions.dart';
import '../view_payment_button.dart';

class Status300Buttons extends StatelessWidget {
  final bool isBuyer;
  final Order order;
  final void Function(OrderAction) onPress;
  final String? paymentMethod;
  const Status300Buttons({
    Key? key,
    this.isBuyer = true,
    required this.order,
    required this.onPress,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.isBuyer) {
      return Container(
        child: Column(
          children: [
            if (order.proofOfPayment?.isNotEmpty ?? false)
              Container(
                width: double.infinity,
                child: ViewPaymentButton(onPress: this.onPress),
              ),
            Container(
              width: double.infinity,
              child: MessageSellerButton(order: this.order),
            ),
          ],
        ),
      );
    }

    return Container(
      child: Column(
        children: [
          if (order.proofOfPayment?.isNotEmpty ?? false)
            Container(
              child: ViewPaymentButton(onPress: this.onPress),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: MessageBuyerButton(order: this.order),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              Expanded(
                child: AppButton(
                  "Confirm Payment",
                  kOrangeColor,
                  true,
                  () => this.onPress(OrderAction.confirmPayment),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
