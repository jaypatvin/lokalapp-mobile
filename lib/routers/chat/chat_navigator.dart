import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import '../../models/app_navigator.dart';
import '../../screens/chat/chat.dart';
import '../../screens/chat/chat_profile.dart';
import '../../screens/chat/chat_view.dart';
import '../../screens/chat/shared_media.dart';
import 'chat_profile.props.dart';
import 'chat_view.props.dart';

class ChatNavigator extends AppNavigator {
  @override
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Chat.routeName:
        return CupertinoPageRoute(builder: (_) => Chat());
      case ChatView.routeName:
        final props = settings.arguments as ChatViewProps;
        return CupertinoPageRoute(
          builder: (_) => ChatView(
            props.createMessage,
            chat: props.chat,
            members: props.members,
            shopId: props.shopId,
            productId: props.productId,
          ),
        );
      case ChatProfile.routeName:
        final props = settings.arguments as ChatProfileProps;
        return CupertinoPageRoute(
          builder: (_) => ChatProfile(
            props.chat,
            props.conversations,
          ),
        );
      case SharedMedia.routeName:
        final conversations =
            (settings.arguments as Map<String, dynamic>)['conversations']!;
        return CupertinoPageRoute(
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
