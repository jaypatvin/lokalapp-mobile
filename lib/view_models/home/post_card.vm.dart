import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../models/activity_feed.dart';
import '../../models/app_navigator.dart';
import '../../providers/activities.dart';
import '../../providers/auth.dart';
import '../../routers/app_router.dart';
import '../../routers/home/post_details.props.dart';
import '../../screens/home/post_details.dart';
import '../../screens/profile/profile_screen.dart';
import '../../state/view_model.dart';
import '../../widgets/photo_view_gallery/gallery/gallery_network_photo_view.dart';

class PostCardViewModel extends ViewModel {
  final bool _isUserLoading = false;
  bool get isUserLoading => _isUserLoading;

  bool isCurrentUser(ActivityFeed activity) =>
      context.read<Auth>().user!.id == activity.userId;

  bool _isLiking = false;
  bool _isDeleting = false;

  @override
  void init() {}

  void goToPostDetails(ActivityFeed activity) {
    context.read<AppRouter>().navigateTo(
          AppRoute.home,
          PostDetails.routeName,
          arguments: PostDetailsProps(
            activityId: activity.id,
            onUserPressed: (_) => onUserPressed(activity),
            onLike: () => onLike(activity),
          ),
        );
  }

  Future<void> onLike(ActivityFeed activity) async {
    if (_isLiking) return;
    final user = context.read<Auth>().user!;
    try {
      _isLiking = true;
      if (activity.liked) {
        await context.read<Activities>().unlikePost(
              activityId: activity.id,
              userId: user.id!,
            );
      } else {
        await context.read<Activities>().likePost(
              activityId: activity.id,
              userId: user.id!,
            );
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      _isLiking = false;
    }
  }

  void onUserPressed(ActivityFeed activity) {
    if (context.read<Auth>().user!.id == activity.userId) {
      context.read<AppRouter>().jumpToTab(AppRoute.profile);
      return;
    }

    context.read<AppRouter>().navigateTo(
      AppRoute.profile,
      ProfileScreen.routeName,
      arguments: {'userId': activity.userId},
    );
  }

  void onPostOptionsPressed(Widget? child) {
    if (child == null) return;

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (_) => child,
    );
  }

  void openGallery(ActivityFeed activity, int index) {
    AppRouter.rootNavigatorKey.currentState?.push(
      AppNavigator.appPageRoute(
        builder: (_) => GalleryNetworkPhotoView(
          galleryItems: activity.images,
          initialIndex: index,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Future<void> onDeletePost(ActivityFeed activity) async {
    if (_isDeleting) return;
    try {
      _isDeleting = true;
      await context.read<Activities>().deleteActivity(activity.id);
    } catch (e) {
      _showError(e.toString());
    } finally {
      _isDeleting = false;
    }
  }

  void onEditPost() {
    showToast('Edit post not implemented!');
  }

  void onCopyLink() {
    showToast('Copy link not implemented!');
  }

  void onHidePost() {
    showToast('Hide post not implemented!');
  }

  void onReportPost() {
    showToast('Report post not implemented!');
  }

  void _showError(String message) {
    showToast(message);
  }
}
