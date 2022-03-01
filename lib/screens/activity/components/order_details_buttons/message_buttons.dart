import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/order.dart';
import '../../../../routers/app_router.dart';
import '../../../../routers/chat/props/chat_details.props.dart';
import '../../../../widgets/app_button.dart';
import '../../../chat/chat_details.dart';

class MessageBuyerButton extends StatelessWidget {
  final Order order;
  const MessageBuyerButton({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton.transparent(
      text: 'Message Buyer',
      onPressed: () {
        context.read<AppRouter>().navigateTo(
              AppRoute.chat,
              ChatDetails.routeName,
              arguments: ChatDetailsProps(
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
        context.read<AppRouter>().navigateTo(
              AppRoute.chat,
              ChatDetails.routeName,
              arguments: ChatDetailsProps(
                members: [order.buyerId, order.shopId],
                shopId: order.shopId,
                productId: order.productIds.firstOrNull,
              ),
            );
      },
    );
  }
}
