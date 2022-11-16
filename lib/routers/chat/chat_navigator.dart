import 'package:flutter/widgets.dart';

import '../../models/app_navigator.dart';
import '../../screens/chat/chat.dart';
import '../../screens/chat/chat_details.dart';
import '../../screens/chat/chat_profile.dart';
import '../../screens/chat/shared_media.dart';
import 'props/chat_details.props.dart';
import 'props/chat_profile.props.dart';

class ChatNavigator extends AppNavigator {
  const ChatNavigator(super.navigatorKey);

  @override
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Chat.routeName:
        return AppNavigator.appPageRoute(
          settings: settings,
          builder: (_) => const Chat(),
        );
      case ChatDetails.routeName:
        final props = settings.arguments! as ChatDetailsProps;
        return AppNavigator.appPageRoute(
          settings: settings,
          builder: (_) => ChatDetails(
            chat: props.chat,
            members: props.members,
            shopId: props.shopId,
            productId: props.productId,
          ),
        );
      case ChatProfile.routeName:
        final props = settings.arguments! as ChatProfileProps;
        return AppNavigator.appPageRoute(
          settings: settings,
          builder: (_) => ChatProfile(
            props.chat,
            props.conversations,
          ),
        );
      case SharedMedia.routeName:
        final conversations =
            (settings.arguments! as Map<String, dynamic>)['conversations'];
        return AppNavigator.appPageRoute(
          settings: settings,
          builder: (_) => SharedMedia(
            conversations: conversations,
          ),
        );
      default:
        // TODO: implement onGenerateRoute
        throw UnimplementedError();
    }
  }
}
