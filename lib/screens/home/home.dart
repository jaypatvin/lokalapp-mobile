import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/activities.dart';
import '../../providers/community.dart';
import '../../providers/notifications.dart';
import '../../routers/app_router.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../cart/cart_container.dart';
import 'components/post_card.dart';
import 'draft_post.dart';
import 'notifications.dart';

class Home extends HookWidget {
  static const routeName = '/home';
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final onDraftPostTap = useCallback(
      () => AppRouter.rootNavigatorKey.currentState
          ?.pushNamed(DraftPost.routeName),
      [],
    );
    final onNotificationsTap = useCallback(
      () => AppRouter.homeNavigatorKey.currentState
          ?.pushNamed(Notifications.routeName),
      [],
    );

    return Scaffold(
      backgroundColor: const Color(0xffF1FAFF),
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        titleText:
            context.watch<CommunityProvider>().community?.name ?? 'Community',
        titleStyle: const TextStyle(color: Colors.white),
        backgroundColor: kTealColor,
        buildLeading: false,
        actions: [
          Consumer<NotificationsProvider>(
            builder: (ctx, notifications, child) {
              if (notifications.displayAlert) {
                return Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    IconButton(
                      onPressed: onNotificationsTap,
                      icon: const Icon(Icons.notifications_rounded),
                    ),
                    const Positioned(
                      right: 8,
                      top: 15,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kPinkColor,
                          ),
                          child: SizedBox(
                            height: 5,
                            width: 5,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return IconButton(
                onPressed: onNotificationsTap,
                icon: const Icon(Icons.notifications_outlined),
              );
            },
          ),
        ],
      ),
      body: CartContainer(
        child: Consumer<Activities>(
          builder: (ctx, activities, _) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _PostField(
                    onDraftPostTap: onDraftPostTap,
                  ),
                ),
                if (activities.isLoading)
                  SliverFillViewport(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Transform.translate(
                          offset: const Offset(0, -150),
                          child: Lottie.asset(
                            kAnimationLoading,
                            // fit: BoxFit.,
                            fit: BoxFit.cover,
                            repeat: true,
                          ),
                        );
                      },
                      childCount: 1,
                    ),
                  )
                else if (activities.feed.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          top: 10,
                          child: SvgPicture.asset(
                            kSvgBackgroundHouses,
                            color: kTealColor,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 62),
                          child: Center(
                            child: Text(
                              'No posts yet! Be the first from your community.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Goldplay',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color(0xFF4F4F4F),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (ctx2, index) {
                          final activity = activities.feed[index];
                          return Padding(
                            padding: index != 0
                                ? const EdgeInsets.only(top: 25)
                                : EdgeInsets.zero,
                            child: PostCard(
                              key: Key(activity.id),
                              activity: activity,
                            ),
                          );
                        },
                        childCount: activities.feed.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PostField extends StatelessWidget {
  const _PostField({
    // ignore: unused_element
    super.key,
    this.onDraftPostTap,
  });
  final void Function()? onDraftPostTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: kInviteScreenColor.withOpacity(0.7),
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: GestureDetector(
        onTap: onDraftPostTap,
        child: Container(
          height: 45.0,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "What's on your mind?",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: Colors.grey.shade400),
              ),
              const Icon(
                MdiIcons.squareEditOutline,
                color: Color(0xffE0E0E0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
