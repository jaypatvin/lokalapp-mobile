import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../models/failure_exception.dart';
import '../../models/lokal_images.dart';
import '../../providers/activities.dart';
import '../../providers/auth.dart';
import '../../services/database.dart';
import '../../services/local_image_service.dart';
import '../../state/view_model.dart';
import '../../utils/constants/assets.dart';
import '../../widgets/photo_picker_gallery/provider/custom_photo_provider.dart';

class PostDetailViewModel extends ViewModel {
  PostDetailViewModel({
    required this.activityId,
    required this.onUserPressed,
    required this.onLike,
  });

  final String activityId;
  final void Function(String) onUserPressed;
  final void Function() onLike;

  late final CustomPickerDataProvider imageProvider;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> commentFeed;
  final TextEditingController inputController = TextEditingController();

  bool _isCommentUploading = false;
  bool _isPostDeleting = false;

  bool _showImagePicker = false;
  bool get showImagePicker => _showImagePicker;
  set showImagePicker(bool value) {
    _showImagePicker = value;
    notifyListeners();
  }

  @override
  void init() {
    imageProvider = context.read<CustomPickerDataProvider>();
    imageProvider.onPickMax.addListener(_showMaxAssetsText);
    imageProvider.pickedNotifier.addListener(_onPick);
    commentFeed = Database.instance.getCommentFeed(activityId);
  }

  @override
  void dispose() {
    imageProvider.picked.clear();
    imageProvider.removeListener(_showMaxAssetsText);
    imageProvider.pickedNotifier.removeListener(_onPick);
    inputController.dispose();
    super.dispose();
  }

  Future<void> onShowImagePicker() async {
    if (!_showImagePicker) {
      final result = await PhotoManager.requestPermissionExtend();
      if (result.isAuth) {
        final pathList = await PhotoManager.getAssetPathList(
          onlyAll: true,
          type: RequestType.image,
        );
        imageProvider.resetPathList(pathList);
      } else {
        if (Platform.isIOS) {
          showToast('Please allow Lokal access to Photos.');
        } else {
          showToast('Please allow Lokal access to your Gallery.');
        }
      }
    }

    showImagePicker = !_showImagePicker;
  }

  void _showMaxAssetsText() =>
      showToast('You have reached the limit of 5 media per post.');

  void _onPick() => notifyListeners();

  void onImageRemove(int index) {
    imageProvider.picked.removeAt(index);
    notifyListeners();
  }

  Future<void> createComment() async {
    if (_isCommentUploading || inputController.text.isEmpty) return;

    _isCommentUploading = true;
    final cUser = context.read<Auth>().user!;
    final service = context.read<LocalImageService>();
    final gallery = <LokalImages>[];
    for (final asset in imageProvider.picked) {
      final file = await asset.file;
      final url = await service.uploadImage(
        file: file!,
        src: kActivityImagesSrc,
      );
      gallery.add(
        LokalImages(
          url: url,
          order: imageProvider.picked.indexOf(asset),
        ),
      );
    }

    final Map<String, dynamic> body = {
      'user_id': cUser.id,
      'message': inputController.text,
      'images': gallery.map((x) => x.toMap()).toList(),
    };

    try {
      await context
          .read<Activities>()
          .createComment(activityId: activityId, body: body);

      _isCommentUploading = false;
      inputController.clear();
      imageProvider.picked.clear();
      notifyListeners();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast('Cannot create a comment: $e');
      _isCommentUploading = false;
      notifyListeners();
    }
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

  Future<void> onDelete() async {
    if (_isPostDeleting) return;
    try {
      _isPostDeleting = true;
      await context.read<Activities>().deleteActivity(activityId);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    } finally {
      _isPostDeleting = false;
    }
  }
}
