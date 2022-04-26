import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../app/app.locator.dart';
import '../../../../app/app.router.dart';
import '../../../../app/app_router.dart';
import '../../../../models/order.dart';
import '../../../../widgets/app_button.dart';

class MessageBuyerButton extends StatelessWidget {
  final Order order;
  const MessageBuyerButton({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton.transparent(
      text: 'Message Buyer',
      onPressed: () {
        locator<AppRouter>().navigateTo(
          AppRoute.chat,
          ChatRoutes.chatDetails,
          arguments: ChatDetailsArguments(
            members: [order.buyerId, order.shopId],
            shopId: order.shopId,
            productId: order.productIds.firstOrNull,
          ),
        );
      },
    );
  }
}

class MessageSellerButton extends StatelessWidget {
  final Order order;

  const MessageSellerButton({Key? key, required this.order}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppButton.transparent(
      text: 'Message Seller',
      onPressed: () {
        locator<AppRouter>().navigateTo(
          AppRoute.chat,
          ChatRoutes.chatDetails,
          arguments: ChatDetailsArguments(
            members: [order.buyerId, order.shopId],
            shopId: order.shopId,
            productId: order.productIds.firstOrNull,
          ),
        );
      },
    );
  }
}
