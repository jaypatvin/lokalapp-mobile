import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../models/activity_feed.dart';
import '../../models/lokal_images.dart';
import '../../providers/activities.dart';
import '../../providers/auth.dart';
import '../../routers/app_router.dart';
import '../../screens/profile/profile_screen.dart';
import '../../services/database.dart';
import '../../services/local_image_service.dart';
import '../../widgets/photo_picker_gallery/provider/custom_photo_provider.dart';

class PostDetailsViewModel extends ChangeNotifier {
  PostDetailsViewModel(
    this.context, {
    required this.userId,
    required this.activityFeed,
  });
  final BuildContext context;
  final String userId;
  final ActivityFeed activityFeed;

  final TextEditingController commentInputController = TextEditingController();
  final FocusNode commentInputFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  final _db = Database.instance;

  late final CustomPickerDataProvider provider;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> commentFeed;
  bool liked = false;

  bool commentUploading = false;
  bool showImagePicker = false;

  void init() {
    provider = context.read<CustomPickerDataProvider>();
    provider.onPickMax.addListener(showMaxAssetsText);
    provider.pickedNotifier.addListener(onPick);
    commentFeed = _db.getCommentFeed(activityFeed.id);
    providerInit();
  }

  @override
  void dispose() {
    provider.picked.clear();
    provider.removeListener(showMaxAssetsText);
    provider.pickedNotifier.removeListener(onPick);
    super.dispose();
  }

  void onPick() {
    Timer(Duration(milliseconds: 300), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      );
    });
  }

  Future<void> providerInit() async {
    final pathList = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: RequestType.image,
    );
    provider.resetPathList(pathList);
  }

  void showMaxAssetsText() {
    final snackBar = SnackBar(
      content: Text("You have reached the limit of 5 media per post."),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void onUserTap() {
    if (context.read<Auth>().user!.id == userId) {
      context.read<AppRouter>().jumpToTab(AppRoute.profile);
      return;
    }

    context.read<AppRouter>().navigateTo(
      AppRoute.profile,
      ProfileScreen.routeName,
      arguments: {'userId': userId},
    );
  }

  void onCommentLongPress(Widget child) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (_) => child,
    );
  }

  void onCreateComment() async {
    if (commentUploading || commentInputController.text.isEmpty) return;

    commentUploading = true;
    final cUser = context.read<Auth>().user!;
    final service = context.read<LocalImageService>();
    final gallery = <LokalImages>[];
    for (var asset in provider.picked) {
      var file = await asset.file;
      var url = await service.uploadImage(file: file!, name: 'post_photo');
      gallery.add(LokalImages(url: url, order: provider.picked.indexOf(asset)));
    }

    Map<String, dynamic> body = {
      "user_id": cUser.id,
      "message": commentInputController.text,
      "images": gallery.map((x) => x.toMap()).toList(),
    };

    try {
      await context.read<Activities>().createComment(
            activityId: activityFeed.id,
            body: body,
          );

      commentUploading = false;
      commentInputController.clear();
      provider.picked.clear();
      notifyListeners();
    } catch (e) {
      commentUploading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot create a comment: $e'),
        ),
      );
    }
  }
}

class CommentFeedViewModel {
  CommentFeedViewModel(this.context, this.activityId);

  final BuildContext context;
  final String activityId;

  final _db = Database.instance;

  Future<bool> isLiked(String commentId) {
    return _db.isCommentLiked(
      activityId: activityId,
      userId: context.read<Auth>().user!.id!,
      commentId: commentId,
    );
  }
}
