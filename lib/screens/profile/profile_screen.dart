import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          child: Text('The user cannot be found.'),
        );
      }
    }

    final isCurrentUser =
        context.read<Auth>().user?.id == userId || userId == null;
    return Scaffold(
      backgroundColor: kInviteScreenColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ProfileHeader(
                userId: userId ?? context.read<Auth>().user!.id,
              ),
              ShopBanner(
                userId: userId ?? context.read<Auth>().user!.id,
              ),
              const SizedBox(height: 30),
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
              left: 0,
              child: Visibility(
                visible: vm.isCurrentUser,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: IconButton(
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.settings,
                      size: 25,
                    ),
                    color: Colors.white,
                    onPressed: vm.onSettingsPressed,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10.0),
                    ChatAvatar(
                      displayName: user.displayName,
                      displayPhoto: user.profilePhoto,
                      radius: 45,
                      onTap: vm.onPhotoTap,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      user.displayName,
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                    ),
                    if (!vm.isCurrentUser) const SizedBox(height: 10.0),
                    if (!vm.isCurrentUser)
                      AppButton.transparent(
                        text: 'Send a Message',
                        color: Colors.white,
                        onPressed: vm.onSendMessage,
                        textStyle: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: vm.isCurrentUser,
              child: Positioned(
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.more_horiz,
                      size: 25,
                    ),
                    color: Colors.white,
                    onPressed: vm.onTripleDotsPressed,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
