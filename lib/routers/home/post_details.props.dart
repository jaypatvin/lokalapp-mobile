class PostDetailsProps {
  const PostDetailsProps({
    //required this.activity,
    required this.activityId,
    required this.onUserPressed,
    required this.onLike,
  });

  //final ActivityFeed activity;
  final String activityId;
  final void Function(String) onUserPressed;
  final void Function() onLike;
}
