import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/app_navigator.dart';
import '../../providers/activities.dart';
import '../../providers/community.dart';
import '../../routers/app_router.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../cart/cart_container.dart';
import 'community_members.dart';
import 'components/post_card.dart';
import 'draft_post.dart';
import 'report_community.dart';

class Home extends HookWidget {
  static const routeName = '/home';
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _onDraftPostTap = useCallback(
      () => AppRouter.rootNavigatorKey.currentState
          ?.pushNamed(DraftPost.routeName),
      [],
    );
    // final _onNotificationsTap = useCallback(
    //   () => AppRouter.homeNavigatorKey.currentState
    //       ?.pushNamed(Notifications.routeName),
    //   [],
    // );

    final _onReportCommunity = useCallback<VoidCallback>(
      () async {
        final _response = await showModalBottomSheet<bool>(
          context: context,
          useRootNavigator: true,
          builder: (ctx) => const _ReportCommunityModalSheet(),
        );

        if (_response == null || !_response) {
          AppRouter.rootNavigatorKey.currentState?.pop();
          return;
        } else {
          AppRouter.rootNavigatorKey.currentState?.pop();
          AppRouter.homeNavigatorKey.currentState?.push(
            AppNavigator.appPageRoute(
              builder: (_) => const ReportCommunity(),
            ),
          );
        }
      },
      [],
    );

    final _onViewMembers = useCallback<VoidCallback>(
      () {
        // this pops the previous modal bottom sheet
        AppRouter.rootNavigatorKey.currentState
          ?..pop()
          ..push(
            AppNavigator.appPageRoute(
              builder: (ctx) => const CommunityMembers(),
            ),
          );
      },
      [],
    );

    // TODO: move to MVVM
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
          IconButton(
            padding: const EdgeInsets.only(right: 16),
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.more_horiz,
              size: 25,
            ),
            color: Colors.white,
            onPressed: () => showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              builder: (ctx) {
                return _HomeModalSheet(
                  onReportCommunity: _onReportCommunity,
                  onViewMembers: _onViewMembers,
                );
              },
            ),
          ),
          // Consumer<NotificationsProvider>(
          //   builder: (ctx, notifications, child) {
          //     if (notifications.displayAlert) {
          //       return Stack(
          //         alignment: AlignmentDirectional.center,
          //         children: [
          //           IconButton(
          //             onPressed: _onNotificationsTap,
          //             icon: const Icon(Icons.notifications_rounded),
          //           ),
          //           const Positioned(
          //             right: 8,
          //             top: 15,
          //             child: Padding(
          //               padding: EdgeInsets.all(8.0),
          //               child: DecoratedBox(
          //                 decoration: BoxDecoration(
          //                   shape: BoxShape.circle,
          //                   color: kPinkColor,
          //                 ),
          //                 child: SizedBox(
          //                   height: 5,
          //                   width: 5,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       );
          //     }
          //     return IconButton(
          //       onPressed: _onNotificationsTap,
          //       icon: const Icon(Icons.notifications_outlined),
          //     );
          //   },
          // ),
        ],
      ),
      body: CartContainer(
        child: Consumer<Activities>(
          builder: (ctx, activities, _) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _PostField(
                    onDraftPostTap: _onDraftPostTap,
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
    Key? key,
    this.onDraftPostTap,
  }) : super(key: key);
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

class _HomeModalSheet extends StatelessWidget {
  const _HomeModalSheet({
    Key? key,
    required this.onReportCommunity,
    required this.onViewMembers,
  }) : super(key: key);

  final VoidCallback onViewMembers;
  final VoidCallback onReportCommunity;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          onTap: onViewMembers,
          leading: const Icon(
            MdiIcons.alertCircleOutline,
            color: kNavyColor,
          ),
          title: Text(
            'View members',
            softWrap: true,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        ListTile(
          onTap: onReportCommunity,
          leading: const Icon(
            MdiIcons.alertCircleOutline,
            color: kPinkColor,
          ),
          title: Text(
            'Report Community',
            softWrap: true,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(color: kPinkColor),
          ),
        ),
      ],
    );
  }
}

class _ReportCommunityModalSheet extends StatelessWidget {
  const _ReportCommunityModalSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 38),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Report community?',
                style: Theme.of(context).textTheme.headline5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 76),
                child: Text(
                  'Our team will review this community.',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 47),
              Row(
                children: [
                  Expanded(
                    child: AppButton.transparent(
                      text: 'Cancel',
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton.filled(
                      text: 'Report',
                      onPressed: () => Navigator.of(context).pop(true),
                      color: kPinkColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
