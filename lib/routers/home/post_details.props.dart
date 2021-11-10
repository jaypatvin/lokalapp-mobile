import '../../models/activity_feed.dart';

class PostDetailsProps {
  const PostDetailsProps({
    required this.activity,
    required this.onUserPressed,
    required this.onLike,
  });

  final ActivityFeed activity;
  final void Function(String) onUserPressed;
  final void Function() onLike;
}
