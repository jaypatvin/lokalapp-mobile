import 'package:flutter/material.dart';
import 'package:lokalapp/models/order.dart';
import 'package:lokalapp/screens/chat/chat_view.dart';

import 'package:lokalapp/utils/themes.dart';

import 'order_button.dart';

class MessageBuyerButton extends StatelessWidget {
  final Order order;
  const MessageBuyerButton({Key key, @required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: ADD MESSAGE BUYER FUNCTION
    return OrderButton("Message Buyer", kTealColor, false, () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => ChatView(
            true,
            members: [order.buyerId, order.shopId],
            shopId: order.shopId,
          ),
        ),
      );
    });
  }
}

class MessageSellerButton extends StatelessWidget {
  final Order order;

  const MessageSellerButton({Key key, this.order}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: ADD MESSAGE SELLER FUNCTION
    return OrderButton("Message Seller", kTealColor, false, () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => ChatView(
            true,
            members: [order.buyerId, order.shopId],
            shopId: order.shopId,
          ),
        ),
      );
    });
  }
}
