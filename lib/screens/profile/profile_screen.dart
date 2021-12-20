import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../providers/users.dart';
import '../../state/mvvm_builder.widget.dart';
import '../../state/views/stateless.view.dart';
import '../../utils/constants/themes.dart';
import '../../utils/shared_preference.dart';
import '../../view_models/profile/profile_screen.vm.dart';
import '../../widgets/app_button.dart';
import '../../widgets/overlays/onboarding.dart';
import '../chat/components/chat_avatar.dart';
import '../home/timeline.dart';
import 'components/current_user_profile.dart';
import 'components/shop_banner.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';
  const ProfileScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<Users>().findById(userId);

    if (user == null) {
      return Center(
        child: Text('Error in displaying the user!'),
      );
    }

    final isCurrentUser = context.read<Auth>().user!.id == userId;
    return Onboarding(
      screen: MainScreen.profile,
      child: Scaffold(
        backgroundColor: kInviteScreenColor,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ProfileHeader(
                  userId: this.userId,
                ),
                ShopBanner(userId: userId),
                Expanded(
                  child: !isCurrentUser
                      ? Container(
                          color: kInviteScreenColor,
                          child: Timeline(userId: userId),
                        )
                      : const CurrentUserProfile(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _ProfileHeaderView(),
      viewModel: ProfileHeaderViewModel(userId),
    );
  }
}

class _ProfileHeaderView extends StatelessView<ProfileHeaderViewModel> {
  Widget _backgroundBuilder(List<Color> colors) {
    return SizedBox(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors,
          ),
        ),
      ),
    );
  }

  @override
  Widget render(BuildContext context, ProfileHeaderViewModel vm) {
    return Consumer<Users>(
      builder: (ctx, users, __) {
        final user = users.findById(vm.userId)!;
        return Stack(
          children: [
            user.profilePhoto != null
                ? Positioned.fill(
                    child: Image(
                      image: NetworkImage(
                        user.profilePhoto ?? '',
                      ),
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, obj, trace) =>
                          _backgroundBuilder(vm.profileHeaderColors),
                    ),
                  )
                : Positioned.fill(
                    child: _backgroundBuilder(vm.profileHeaderColors),
                  ),
            Positioned.fill(
              child: SizedBox(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.30),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10.0.w,
              child: Visibility(
                visible: vm.isCurrentUser,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.settings,
                    size: 30.0.r,
                  ),
                  color: Colors.white,
                  onPressed: vm.onSettingsPressed,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10.0.h, bottom: 10.0.h),
                child: Column(
                  children: [
                    SizedBox(height: 10.0.h),
                    ChatAvatar(
                      displayName: user.displayName,
                      displayPhoto: user.profilePhoto,
                      radius: 40.0.r,
                      onTap: vm.onPhotoTap,
                    ),
                    SizedBox(height: 10.0.h),
                    Text(
                      user.displayName!,
                      style: TextStyle(
                        fontSize: 18.0.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10.0.h),
                    if (!vm.isCurrentUser)
                      SizedBox(
                        width: 140.w,
                        child: AppButton(
                          'Send a Message',
                          Colors.white,
                          false,
                          vm.onSendMessage,
                          textStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: vm.isCurrentUser,
              child: Positioned(
                right: 10.0.w,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.more_horiz,
                    size: 30.0.r,
                  ),
                  color: Colors.white,
                  onPressed: vm.onTripleDotsPressed,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
