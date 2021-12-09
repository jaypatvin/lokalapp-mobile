import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lokalapp/services/database.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../models/lokal_images.dart';
import '../../providers/activities.dart';
import '../../providers/auth.dart';
import '../../services/local_image_service.dart';
import '../../state/view_model.dart';
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

  @override
  void init() {
    imageProvider = context.read<CustomPickerDataProvider>();
    imageProvider.onPickMax.addListener(_showMaxAssetsText);
    imageProvider.pickedNotifier.addListener(_onPick);
    commentFeed = Database.instance.getCommentFeed(activityId);
    _providerInit();
  }

  @override
  void dispose() {
    imageProvider.picked.clear();
    imageProvider.removeListener(_showMaxAssetsText);
    imageProvider.pickedNotifier.removeListener(_onPick);
    inputController.dispose();
    super.dispose();
  }

  Future<void> _providerInit() async {
    final pathList = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: RequestType.image,
    );
    imageProvider.resetPathList(pathList);
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
    for (var asset in imageProvider.picked) {
      var file = await asset.file;
      var url = await service.uploadImage(file: file!, name: 'post_photo');
      gallery.add(
        LokalImages(
          url: url,
          order: imageProvider.picked.indexOf(asset),
        ),
      );
    }

    Map<String, dynamic> body = {
      "user_id": cUser.id,
      "message": inputController.text,
      "images": gallery.map((x) => x.toMap()).toList(),
    };

    try {
      await context
          .read<Activities>()
          .createComment(activityId: this.activityId, body: body);

      _isCommentUploading = false;
      inputController.clear();
      imageProvider.picked.clear();
      notifyListeners();
    } catch (e) {
      _isCommentUploading = false;
      notifyListeners();
      showToast('Cannot create a comment: $e');
    }
  }
}
