import 'package:flutter/material.dart';

import '../../../../models/order.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../widgets/app_button.dart';
import '../../../chat/chat_view.dart';

class MessageBuyerButton extends StatelessWidget {
  final Order? order;
  const MessageBuyerButton({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: ADD MESSAGE BUYER FUNCTION
    return AppButton("Message Buyer", kTealColor, false, () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => ChatView(
            true,
            members: [order!.buyerId, order!.shopId],
            shopId: order!.shopId,
          ),
        ),
      );
    });
  }
}

class MessageSellerButton extends StatelessWidget {
  final Order order;

  const MessageSellerButton({Key? key, required this.order}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppButton("Message Seller", kTealColor, false, () {
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
