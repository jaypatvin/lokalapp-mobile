import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../app/app_router.dart';
import '../../../utils/constants/themes.dart';

class MyProfileList extends HookWidget {
  const MyProfileList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: separate ViewModel (without BuildContext)
    final onMyPostsTap = useCallback<VoidCallback>(
      () => locator<AppRouter>().navigateTo(
        AppRoute.profile,
        ProfileScreenRoutes.profilePosts,
      ),
      [],
    );

    final onWishlistTap = useCallback<VoidCallback>(
      () => locator<AppRouter>().navigateTo(
        AppRoute.profile,
        ProfileScreenRoutes.wishlistScreen,
      ),
      [],
    );

    final onInviteFriend = useCallback<VoidCallback>(
      () => context.read<AppRouter>().navigateTo(
            AppRoute.profile,
            ProfileScreenRoutes.inviteAFriend,
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
