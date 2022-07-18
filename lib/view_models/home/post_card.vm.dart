import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/app_router.dart';
import '../../models/activity_feed.dart';
import '../../models/app_navigator.dart';
import '../../models/failure_exception.dart';
import '../../providers/activities.dart';
import '../../providers/auth.dart';
import '../../screens/home/report_post.dart';
import '../../screens/profile/profile_screen.dart';
import '../../state/view_model.dart';
import '../../utils/functions.utils.dart' as utils;

class PostCardViewModel extends ViewModel {
  PostCardViewModel({required this.reportPostModalSheet});

  final Widget reportPostModalSheet;
  final bool _isUserLoading = false;
  bool get isUserLoading => _isUserLoading;

  bool isCurrentUser(ActivityFeed activity) =>
      context.read<Auth>().user?.id == activity.userId;

  // bool _isLiking = false;
  bool _isDeleting = false;

  final _appRouter = locator<AppRouter>();

  void goToPostDetails(ActivityFeed activity) {
    _appRouter.navigateTo(
      AppRoute.home,
      HomeRoutes.postDetails,
      arguments: PostDetailsArguments(
        activityId: activity.id,
        onUserPressed: (_) => _onUserPressed(activity),
        onLike: () => onLike(activity),
      ),
    );
  }

  Future<void> onLike(ActivityFeed activity) async {
    // if (_isLiking) return;
    final user = context.read<Auth>().user!;
    try {
      // _isLiking = true;
      if (activity.liked) {
        await context.read<Activities>().unlikePost(
              activityId: activity.id,
              userId: user.id,
            );
      } else {
        await context.read<Activities>().likePost(
              activityId: activity.id,
              userId: user.id,
            );
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    } finally {
      // _isLiking = false;
    }
  }

  void _onUserPressed(ActivityFeed activity) {
    // if the user is tapping on their own post, just change the tab index
    // of the navigation bar
    if (context.read<Auth>().user!.id == activity.userId) {
      _appRouter.jumpToTab(AppRoute.profile);
      return;
    }

    // otherwise, we push a new screen inside the current navigation stack
    final appRoute = _appRouter.currentTabRoute;
    _appRouter.pushDynamicScreen(
      appRoute,
      AppNavigator.appPageRoute(
        builder: (_) => ProfileScreen(
          userId: activity.userId,
        ),
      ),
    );
  }

  void onPostOptionsPressed(Widget? child) {
    if (child == null) return;

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      builder: (_) => child,
    );
  }

  void openGallery(ActivityFeed activity, int index) =>
      utils.openGallery(context, index, activity.images);

  Future<void> onDeletePost(ActivityFeed activity) async {
    if (_isDeleting) return;
    try {
      _isDeleting = true;
      await context.read<Activities>().deleteActivity(activity.id);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
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

  Future<void> onReportPost({required String activityId}) async {
    final response = await showModalBottomSheet<bool>(
      context: context,
      useRootNavigator: true,
      isDismissible: true,
      builder: (_) => reportPostModalSheet,
    );

    if (response == null || !response) {
      AppRouter.rootNavigatorKey?.currentState?.pop();
      return;
    } else {
      AppRouter.rootNavigatorKey?.currentState?.pop();
      AppRouter.homeNavigatorKey?.currentState?.push(
        AppNavigator.appPageRoute(
          builder: (_) => ReportPost(
            activityId: activityId,
          ),
        ),
      );
    }
  }
}
