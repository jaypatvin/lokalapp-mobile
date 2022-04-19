import 'package:provider/provider.dart';

import '../../../models/app_navigator.dart';
import '../../../routers/app_router.dart';
import '../../../screens/profile/profile_posts.dart';
import '../../../screens/profile/settings/invite_a_friend/invite_a_friend.dart';
import '../../../screens/profile/wishlist_screen.dart';
import '../../../state/view_model.dart';

class CurrentUserProfileViewModel extends ViewModel {
  CurrentUserProfileViewModel();

  void onMyPostsTap() {
    AppRouter.profileNavigatorKey.currentState?.push(
      AppNavigator.appPageRoute(builder: (_) => const ProfilePosts()),
    );
  }

  void onInviteFriend() {
    context.read<AppRouter>().navigateTo(
          AppRoute.profile,
          InviteAFriend.routeName,
        );
  }

  void onWishlistTap() {
    context.read<AppRouter>().navigateTo(
          AppRoute.profile,
          WishlistScreen.routeName,
        );
  }
}
