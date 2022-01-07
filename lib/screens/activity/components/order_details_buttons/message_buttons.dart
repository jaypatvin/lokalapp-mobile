import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/order.dart';
import '../../../../routers/app_router.dart';
import '../../../../routers/chat/chat_view.props.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../widgets/app_button.dart';
import '../../../chat/chat_view.dart';

class MessageBuyerButton extends StatelessWidget {
  final Order? order;
  const MessageBuyerButton({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: ADD MESSAGE BUYER FUNCTION
    return AppButton('Message Buyer', kTealColor, false, () {
      context.read<AppRouter>().navigateTo(
            AppRoute.chat,
            ChatView.routeName,
            arguments: ChatViewProps(
              members: [order!.buyerId!, order!.shopId!],
              shopId: order!.shopId,
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
    return AppButton('Message Seller', kTealColor, false, () {
      context.read<AppRouter>().navigateTo(
            AppRoute.chat,
            ChatView.routeName,
            arguments: ChatViewProps(
              members: [order.buyerId!, order.shopId!],
              shopId: order.shopId,
            ),
          );
    });
  }
}
