import 'package:flutter/material.dart';

import '../../../models/order.dart';
import 'order_details_buttons/message_buttons.dart';
import 'order_details_buttons/order_actions.dart';
import 'order_details_buttons/status_buttons/status_100.dart';
import 'order_details_buttons/status_buttons/status_200.dart';
import 'order_details_buttons/status_buttons/status_300.dart';
import 'order_details_buttons/status_buttons/status_400.dart';
import 'order_details_buttons/status_buttons/status_500.dart';
import 'order_details_buttons/status_buttons/status_600.dart';

class OrderDetailsButtons extends StatelessWidget {
  const OrderDetailsButtons({
    required this.statusCode,
    required this.isBuyer,
    required this.order,
    required this.onPress,
  });

  final int statusCode;
  final bool isBuyer;
  final Order order;
  final void Function(OrderAction) onPress;

  @override
  Widget build(BuildContext context) {
    switch (statusCode) {
      case 100:
        return Status100Buttons(
          isBuyer: isBuyer,
          order: order,
          onPress: onPress,
        );
      case 200:
        return Status200Buttons(
          isBuyer: isBuyer,
          order: order,
          onPress: onPress,
        );
      case 300:
        return Status300Buttons(
          isBuyer: isBuyer,
          order: order,
          onPress: onPress,
          paymentMethod: order.paymentMethod,
        );
      case 400:
        return Status400Buttons(
          isBuyer: isBuyer,
          order: order,
          onPress: onPress,
          paymentMethod: order.paymentMethod,
        );
      case 500:
        return Status500Buttons(
          isBuyer: isBuyer,
          order: order,
          onPress: onPress,
          paymentMethod: order.paymentMethod,
        );
      case 600:
        return Status600Buttons(
          isBuyer: isBuyer,
          order: order,
          onPress: onPress,
          paymentMethod: order.paymentMethod,
        );
      default:
        return isBuyer
            ? SizedBox(
                width: double.infinity,
                child: MessageSellerButton(order: order),
              )
            : SizedBox(
                width: double.infinity,
                child: MessageBuyerButton(order: order),
              );
    }
  }
}
