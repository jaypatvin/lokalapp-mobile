import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import '../../widgets/persistent_header_delegate_builder.dart';
import '../cart/cart_container.dart';
import 'components/post_card.dart';
import 'draft_post.dart';
import 'notifications.dart';

class Home extends HookWidget {
  static const routeName = '/home';
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _postFieldHeight = useRef(75.0.h);
    final _onDraftPostTap = useCallback(
      () => AppRouter.rootNavigatorKey.currentState
          ?.pushNamed(DraftPost.routeName),
      [],
    );
    final _onNotificationsTap = useCallback(
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
                      onPressed: _onNotificationsTap,
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
                onPressed: _onNotificationsTap,
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
                SliverPersistentHeader(
                  floating: true,
                  delegate: PersistentHeaderDelegateBuilder(
                    maxHeight: _postFieldHeight.value,
                    minHeight: _postFieldHeight.value,
                    child: _PostField(
                      height: _postFieldHeight.value,
                      onDraftPostTap: _onDraftPostTap,
                    ),
                  ),
                ),
                if (activities.isLoading)
                  SliverFillViewport(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Transform.translate(
                          offset: Offset(0, -150.h),
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
                  const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No posts yet! Be the first one to post.',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx2, index) {
                        final activity = activities.feed[index];
                        return PostCard(
                          key: Key(activity.id),
                          activity: activity,
                        );
                      },
                      childCount: activities.feed.length,
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
    this.height = 75.0,
    this.onDraftPostTap,
  }) : super(key: key);
  final double height;
  final void Function()? onDraftPostTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: kInviteScreenColor.withOpacity(0.7),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0.w,
          vertical: 15.h,
        ),
        child: GestureDetector(
          onTap: onDraftPostTap,
          child: Container(
            height: 50.0.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15.0.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.all(Radius.circular(15.0.r)),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "What's on your mind?",
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(
                  MdiIcons.squareEditOutline,
                  color: Color(0xffE0E0E0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
