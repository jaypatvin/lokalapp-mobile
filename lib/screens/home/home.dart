import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/activities.dart';
import '../../providers/community.dart';
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
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _postFieldHeight = useRef(75.0.h);
    final _onDraftPostTap = useCallback(
      () => AppRouter.rootNavigatorKey.currentState
          ?.pushNamed(DraftPost.routeName),
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
          IconButton(
            onPressed: () => context
                .read<AppRouter>()
                .keyOf(AppRoute.home)
                .currentState!
                .pushNamed(Notifications.routeName),
            icon: const Icon(Icons.notifications_outlined),
          )
        ],
      ),
      body: CartContainer(
        child: Consumer<Activities>(
          builder: (ctx, activities, _) {
            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  floating: true,
                  delegate: _PersistentPostFieldDelegate(
                    height: _postFieldHeight.value,
                    child: _PostField(
                      height: _postFieldHeight.value,
                      onDraftPostTap: _onDraftPostTap,
                    ),
                  ),
                ),
                if (activities.isLoading)
                  SliverFillRemaining(
                    child: Lottie.asset(
                      kAnimationLoading,
                      fit: BoxFit.cover,
                      repeat: true,
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

class _PersistentPostFieldDelegate extends SliverPersistentHeaderDelegate {
  const _PersistentPostFieldDelegate({
    required this.child,
    this.height = 75.0,
  });

  final Widget child;
  final double height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
