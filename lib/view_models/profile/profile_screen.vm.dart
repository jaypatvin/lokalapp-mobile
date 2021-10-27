import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../models/lokal_user.dart';
import '../../providers/auth.dart';
import '../../providers/users.dart';
import '../../screens/chat/chat_view.dart';
import '../../screens/profile/edit_profile.dart';
import '../../screens/profile/settings/settings.dart';
import '../../utils/constants/themes.dart';

// TODO: change method of pushing screens
class ProfileScreenViewModel {
  ProfileScreenViewModel(this.context, this.userId);

  final BuildContext context;
  final String userId;

  bool get isCurrentUser => _authProvider.user!.id == userId;
  List<Color> get profileHeaderColors => isCurrentUser
      ? const [Color(0xffFFC700), Colors.black45]
      : const [kPinkColor, Colors.black45];

  late final LokalUser user;
  late final Auth _authProvider;

  void init() {
    this._authProvider = context.read<Auth>();
    this.user = isCurrentUser
        ? context.read<Auth>().user!
        : context.read<Users>().findById(userId);
  }

  void onSendMessage() {
    if (_authProvider.user == this.user) {
      throw 'Cannot send message to self.';
    }

    pushNewScreen(
      context,
      screen: ChatView(
        true,
        members: [context.read<Auth>().user!.id, user.id],
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
