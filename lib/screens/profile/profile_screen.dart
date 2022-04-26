import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../providers/activities.dart';
import '../../providers/auth.dart';
import '../../providers/users.dart';
import '../../state/mvvm_builder.widget.dart';
import '../../state/views/stateless.view.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/profile/profile_screen.vm.dart';
import '../../widgets/app_button.dart';
import '../chat/components/chat_avatar.dart';
import '../home/components/post_card.dart';
import 'components/my_profile_list.dart';
import 'components/shop_banner.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key, this.userId}) : super(key: key);
  final String? userId;

  @override
  Widget build(BuildContext context) {
    final _slivers = useRef<List<Widget>>(
      [
        SliverToBoxAdapter(
          child: _ProfileHeader(
            userId: userId ?? context.read<Auth>().user!.id,
          ),
        ),
        SliverToBoxAdapter(
          child: ShopBanner(
            userId: userId ?? context.read<Auth>().user!.id,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 30)),
      ],
    );

    final _isCurrentUser =
        useRef<bool>(context.read<Auth>().user?.id == userId || userId == null);

    if (userId != null) {
      final user = context.watch<Users>().findById(userId);

      if (user == null) {
        return const Center(
          child: Text('The user cannot be found.'),
        );
      }
    }

    return Scaffold(
      backgroundColor: kInviteScreenColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: Builder(
            builder: (context) {
              if (_isCurrentUser.value) {
                return CustomScrollView(
                  slivers: [
                    ..._slivers.value,
                    // const SliverFillRemaining(
                    //   child: CurrentUserProfile(),
                    // ),
                    const SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          'My Profile',
                          style: TextStyle(
                            fontSize: 14,
                            color: kTealColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const MyProfileList(),
                  ],
                );
              } else {
                return Consumer<Activities>(
                  builder: (ctx, activities, _) {
                    final feed = activities.findByUser(userId);
                    return CustomScrollView(
                      slivers: [
                        ..._slivers.value,
                        if (feed.isEmpty)
                          const SliverToBoxAdapter(
                            child: Center(
                              child: SizedBox(
                                height: 50,
                                child: Text(
                                  'No posts yet!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (ctx2, index) {
                                  final activity = feed[index];
                                  return Padding(
                                    padding: index == 0
                                        ? EdgeInsets.zero
                                        : const EdgeInsets.only(top: 20),
                                    child: PostCard(
                                      key: Key(activity.id),
                                      activity: activity,
                                    ),
                                  );
                                },
                                childCount: feed.length,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                );
              }
            },
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
