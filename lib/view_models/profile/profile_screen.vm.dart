import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../routers/app_router.dart';
import '../../routers/chat/chat_view.props.dart';
import '../../screens/chat/chat_view.dart';
import '../../screens/profile/edit_profile.dart';
import '../../screens/profile/settings/settings.dart';
import '../../state/view_model.dart';
import '../../utils/constants/themes.dart';

class ProfileHeaderViewModel extends ViewModel {
  ProfileHeaderViewModel(this.userId);
  final String userId;

  bool get isCurrentUser => _authProvider.user!.id == userId;
  List<Color> get profileHeaderColors => isCurrentUser
      ? const [Color(0xffFFC700), Colors.black45]
      : const [kPinkColor, Colors.black45];

  late final Auth _authProvider;

  @override
  void init() {
    this._authProvider = context.read<Auth>();
  }

  void onSendMessage() {
    if (_authProvider.user?.id == this.userId) {
      throw 'Cannot send message to self.';
    }
    context
      ..read<AppRouter>().navigateTo(
        AppRoute.chat,
        ChatView.routeName,
        arguments: ChatViewProps(
          true,
          members: [context.read<Auth>().user!.id!, userId],
        ),
      );
  }

  void onSettingsPressed() {
    if (isCurrentUser) {
      pushNewScreenWithRouteSettings(
        context,
        screen: Settings(),
        settings: RouteSettings(name: Settings.routeName),
      );
    } else {
      debugPrint('What to do?');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('What to do?'),
        ),
      );
    }
  }

  void onTripleDotsPressed() {
    if (isCurrentUser) {
      pushNewScreen(context, screen: EditProfile());
    } else {
      debugPrint('What to do?');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('What to do?'),
        ),
      );
    }
  }
}
