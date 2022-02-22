import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../models/activity_feed_comment.dart';
import '../../models/app_navigator.dart';
import '../../providers/activities.dart';
import '../../providers/auth.dart';
import '../../routers/app_router.dart';
import '../../screens/profile/profile_screen.dart';
import '../../services/database.dart';
import '../../state/view_model.dart';

class CommentCardViewModel extends ViewModel {
  CommentCardViewModel({
    required this.activityId,
    required this.comment,
  });
  final ActivityFeedComment comment;
  final String activityId;

  bool isLiked = false;

  final _db = Database.instance;

  @override
  void init() {
    _setup();
  }

  Future<void> _setup() async {
    isLiked = await _db.isCommentLiked(
      activityId: activityId,
      userId: context.read<Auth>().user!.id!,
      commentId: comment.id,
    );

    notifyListeners();
  }

  Future<void> refresh() async => _setup();

  void onLongPress({required Widget dialog}) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (_) => dialog,
    );
  }

  void onUserPressed() {
    // if the user is tapping on their own post, just change the tab index
    // of the navigation bar
    if (context.read<Auth>().user!.id == comment.userId) {
      context.read<AppRouter>().jumpToTab(AppRoute.profile);
      return;
    }

    // otherwise, we push a new screen inside the current navigation stack
    final appRoute = context.read<AppRouter>().currentTabRoute;
    context.read<AppRouter>().pushDynamicScreen(
          appRoute,
          AppNavigator.appPageRoute(
            builder: (_) => ProfileScreen(
              userId: comment.userId,
            ),
          ),
        );
  }

  void onLike() {
    try {
      if (isLiked) {
        context.read<Activities>().unlikeComment(
              activityId: activityId,
              commentId: comment.id,
              userId: context.read<Auth>().user!.id!,
            );
        isLiked = false;
        notifyListeners();
        debugPrint('Unliked comment ${comment.id}');
      } else {
        context.read<Activities>().likeComment(
              activityId: activityId,
              commentId: comment.id,
              userId: context.read<Auth>().user!.id!,
            );
        isLiked = true;
        notifyListeners();
        debugPrint('Liked comment ${comment.id}');
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast('Error liking comment!');
      isLiked = !isLiked;
      notifyListeners();
    }
  }

  Future<void> onDelete() async {
    try {
      await context.read<Activities>().deleteComment(
            activityId: activityId,
            commentId: comment.id,
          );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast('There was an error in deleting the comment');
      notifyListeners();
    }
  }
}
