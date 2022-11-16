import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../models/app_navigator.dart';
import '../../../routers/app_router.dart';
import '../../../utils/constants/themes.dart';
import '../profile_posts.dart';
import '../settings/invite_a_friend/invite_a_friend.dart';
import '../wishlist_screen.dart';

class MyProfileList extends HookWidget {
  const MyProfileList({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: separate ViewModel (without BuildContext)
    final onMyPostsTap = useCallback<VoidCallback>(
      () => AppRouter.profileNavigatorKey.currentState?.push(
        AppNavigator.appPageRoute(builder: (_) => const ProfilePosts()),
      ),
      [],
    );

    final onWishlistTap = useCallback<VoidCallback>(
      () => context.read<AppRouter>().navigateTo(
            AppRoute.profile,
            WishlistScreen.routeName,
          ),
      [],
    );

    final onInviteFriend = useCallback<VoidCallback>(
      () => context.read<AppRouter>().navigateTo(
            AppRoute.profile,
            InviteAFriend.routeName,
          ),
      [],
    );

    return SliverList(
      delegate: SliverChildListDelegate(
        ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              tileColor: Colors.white,
              title: const Text(
                'My Posts',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kTealColor,
                size: 14,
              ),
              onTap: onMyPostsTap,
              enableFeedback: true,
            ),
            ListTile(
              tileColor: Colors.white,
              title: const Text(
                'Wishlist',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kTealColor,
                size: 14,
              ),
              onTap: onWishlistTap,
            ),
            ListTile(
              tileColor: Colors.white,
              title: const Text(
                'Invite a Friend',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kTealColor,
                size: 14,
              ),
              onTap: onInviteFriend,
            ),
          ],
        ).toList(),
      ),
    );
  }
}
