import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../models/lokal_images.dart';
import '../../providers/auth.dart';
import '../../providers/users.dart';
import '../../routers/app_router.dart';
import '../../routers/chat/props/chat_view.props.dart';
import '../../screens/chat/chat_view.dart';
import '../../screens/profile/edit_profile.dart';
import '../../screens/profile/settings/settings.dart';
import '../../state/view_model.dart';
import '../../utils/constants/themes.dart';
import '../../utils/functions.utils.dart';

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
    _authProvider = context.read<Auth>();
  }

  void onSendMessage() {
    if (_authProvider.user?.id == userId) {
      throw 'Cannot send message to self.';
    }
    context.read<AppRouter>().navigateTo(
          AppRoute.chat,
          ChatView.routeName,
          arguments: ChatViewProps(
            members: [context.read<Auth>().user!.id!, userId],
          ),
        );
  }

  void onSettingsPressed() {
    if (isCurrentUser) {
      AppRouter.profileNavigatorKey.currentState?.pushNamed(Settings.routeName);
    } else {
      showToast('Nothing to do here!');
    }
  }

  void onTripleDotsPressed() {
    if (isCurrentUser) {
      AppRouter.profileNavigatorKey.currentState?.pushNamed(
        EditProfile.routeName,
      );
    } else {
      showToast('Nothing to do here!');
    }
  }

  void onPhotoTap() {
    final user = context.read<Users>().findById(userId)!;
    if (user.profilePhoto != null) {
      openGallery(context, 0, [
        LokalImages(
          url: user.profilePhoto!,
          order: 0,
        ),
      ]);
    }
  }
}
