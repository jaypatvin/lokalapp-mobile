import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/activity_feed_comment.dart';
import '../../providers/activities.dart';
import '../../providers/auth.dart';
import '../../routers/app_router.dart';
import '../../screens/profile/profile_screen.dart';
import '../../services/database.dart';

class CommentCardViewModel extends ChangeNotifier {
  CommentCardViewModel({
    required this.context,
    required this.activityId,
    required this.comment,
  });
  final ActivityFeedComment comment;
  final String activityId;
  final BuildContext context;

  bool isLiked = false;

  final _db = Database.instance;
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

  Future<void> refresh() async => await _setup();

  void onLongPress(Widget child) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (_) => child,
    );
  }

  void onUserPressed() {
    if (context.read<Auth>().user!.id == comment.userId) {
      context.read<AppRouter>().jumpToTab(AppRoute.profile);
      return;
    }

    context.read<AppRouter>().navigateTo(
      AppRoute.profile,
      ProfileScreen.routeName,
      arguments: {'userId': comment.userId},
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
        debugPrint("Unliked comment ${comment.id}");
      } else {
        context.read<Activities>().likeComment(
              activityId: activityId,
              commentId: comment.id,
              userId: context.read<Auth>().user!.id!,
            );
        isLiked = true;
        notifyListeners();
        debugPrint("Liked comment ${comment.id}");
      }
    } catch (e) {
      isLiked = !isLiked;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }
}