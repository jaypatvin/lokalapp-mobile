import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/app_router.dart';
import '../../models/lokal_images.dart';
import '../../providers/auth.dart';
import '../../providers/users.dart';
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

  final _appRouter = locator<AppRouter>();

  @override
  void init() {
    _authProvider = context.read<Auth>();
  }

  void onSendMessage() {
    if (_authProvider.user?.id == userId) {
      throw 'Cannot send message to self.';
    }
    _appRouter.navigateTo(
      AppRoute.chat,
      ChatRoutes.chatDetails,
      arguments: ChatDetailsArguments(
        members: [context.read<Auth>().user!.id, userId],
      ),
    );
  }

  void onSettingsPressed() {
    if (isCurrentUser) {
      _appRouter.navigateTo(AppRoute.profile, ProfileScreenRoutes.settings);
    } else {
      showToast('Nothing to do here!');
    }
  }

  void onTripleDotsPressed() {
    if (isCurrentUser) {
      _appRouter.navigateTo(AppRoute.profile, ProfileScreenRoutes.editProfile);
    } else {
      showToast('Nothing to do here!');
    }
  }

  void onPhotoTap() {
    final user = context.read<Users>().findById(userId);
    if (user?.profilePhoto != null) {
      openGallery(context, 0, [
        LokalImages(
          url: user!.profilePhoto!,
          order: 0,
        ),
      ]);
    }
  }
}
