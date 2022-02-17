import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../providers/auth.dart';
import '../../providers/users.dart';
import '../../state/mvvm_builder.widget.dart';
import '../../state/views/stateless.view.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/profile/profile_screen.vm.dart';
import '../../widgets/app_button.dart';
import '../chat/components/chat_avatar.dart';
import 'components/current_user_profile.dart';
import 'components/shop_banner.dart';
import 'components/timeline.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  const ProfileScreen({Key? key, this.userId}) : super(key: key);
  final String? userId;

  @override
  Widget build(BuildContext context) {
    if (userId != null) {
      final user = context.watch<Users>().findById(userId);

      if (user == null) {
        return const Center(
          child: Text('Error in displaying the user!'),
        );
      }
    }

    final isCurrentUser =
        context.read<Auth>().user!.id == userId || userId == null;
    return Scaffold(
      backgroundColor: kInviteScreenColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ProfileHeader(
                userId: userId ?? context.read<Auth>().user!.id!,
              ),
              ShopBanner(
                userId: userId ?? context.read<Auth>().user!.id!,
              ),
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
            if (user.profilePhoto != null)
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: user.profilePhoto ?? '',
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Shimmer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                  errorWidget: (ctx, url, err) =>
                      _backgroundBuilder(vm.profileHeaderColors),
                ),
              )
            else
              Positioned.fill(
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
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                    ),
                    SizedBox(height: 10.0.h),
                    if (!vm.isCurrentUser)
                      AppButton.transparent(
                        text: 'Send a Message',
                        color: Colors.white,
                        onPressed: vm.onSendMessage,
                        textStyle: const TextStyle(
                          color: Colors.white,
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
