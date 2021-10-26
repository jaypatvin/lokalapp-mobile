import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/lokal_user.dart';
import '../../providers/activities.dart';
import '../../utils/constants/themes.dart';
import '../../utils/shared_preference.dart';
import '../../view_models/profile/profile_screen.vm.dart';
import '../../widgets/app_button.dart';
import '../../widgets/overlays/onboarding.dart';
import '../chat/components/chat_avatar.dart';
import '../home/timeline.dart';
import 'components/current_user_profile.dart';
import 'components/user_shop_banner.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key, required this.userId}) : super(key: key);
  static const routeName = '/profile';
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Onboarding(
      screen: MainScreen.profile,
      child: Scaffold(
        backgroundColor: kInviteScreenColor,
        body: SafeArea(
          child: Provider(
            create: (ctx) => ProfileScreenViewModel(
              ctx,
              this.userId,
            )..init(),
            builder: (ctx, _) {
              final vm = ctx.read<ProfileScreenViewModel>();
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ProfileHeader(
                    user: vm.user,
                    displaySettings: vm.isCurrentUser,
                    displaySendMessageButton: !vm.isCurrentUser,
                    onMessageSend: vm.onSendMessage,
                    onSettingsPressed: vm.onSettingsPressed,
                    onTripleDotsPressed: vm.onTripleDotsPressed,
                    backgroundGradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: vm.profileHeaderColors,
                    ),
                  ),
                  UserShopBanner(userId: this.userId),
                  Expanded(
                    child: !vm.isCurrentUser
                        ? Container(
                            color: kInviteScreenColor,
                            child: RefreshIndicator(
                              onRefresh: () =>
                                  context.read<Activities>().fetch(),
                              child: Timeline(
                                context.read<Activities>().findByUser(userId),
                                null,
                              ),
                            ),
                          )
                        : const CurrentUserProfile(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    Key? key,
    required this.user,
    this.displaySettings = true,
    this.displaySendMessageButton = false,
    this.onSettingsPressed,
    this.onMessageSend,
    this.onTripleDotsPressed,
    this.backgroundGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xffFFC700), Colors.black45],
    ),
  }) : super(key: key);

  final LokalUser user;
  final bool displaySettings;
  final bool displaySendMessageButton;
  final void Function()? onSettingsPressed;
  final void Function()? onMessageSend;
  final void Function()? onTripleDotsPressed;
  final LinearGradient backgroundGradient;

  get kPinkColor => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0.h, bottom: 10.0.h),
      decoration: BoxDecoration(
        gradient: this.backgroundGradient,
      ),
      child: Stack(
        children: [
          Positioned(
            left: 10.0.w,
            child: Visibility(
              visible: displaySettings,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.settings,
                  size: 30.0.r,
                ),
                color: Colors.white,
                onPressed: onSettingsPressed,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10.0.h),
              child: Column(
                children: [
                  ChatAvatar(
                    displayName: user.displayName,
                    displayPhoto: user.profilePhoto,
                    radius: 40.0.r,
                  ),
                  Text(
                    user.displayName!,
                    style: TextStyle(
                      fontSize: 18.0.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (this.displaySendMessageButton)
                    SizedBox(
                      width: 120.w,
                      child: AppButton(
                        "Send a Message",
                        Colors.white,
                        false,
                        this.onMessageSend,
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 10.0.w,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.more_horiz,
                size: 30.0.r,
              ),
              color: Colors.white,
              onPressed: this.onTripleDotsPressed,
            ),
          ),
        ],
      ),
    );
  }
}
