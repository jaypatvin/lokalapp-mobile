import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../models/lokal_images.dart';
import '../../providers/activities.dart';
import '../../providers/auth.dart';
import '../../routers/app_router.dart';
import '../../services/local_image_service.dart';
import '../../state/view_model.dart';
import '../../widgets/photo_picker_gallery/provider/custom_photo_provider.dart';
import '../../widgets/photo_view_gallery/gallery/gallery_asset_photo_view.dart';

class DraftPostViewModel extends ViewModel {
  DraftPostViewModel();
  late final CustomPickerDataProvider imageProvider;

  String? _postMessage;
  String? get postMessage => _postMessage;

  @override
  void init() {
    imageProvider = context.read<CustomPickerDataProvider>();
    imageProvider.onPickMax.addListener(_showMaxAssetsText);
    imageProvider.pickedNotifier.addListener(_onPick);
    _providerInit();
  }

  @override
  void dispose() {
    imageProvider.picked.clear();
    imageProvider.removeListener(_showMaxAssetsText);
    imageProvider.pickedNotifier.removeListener(_onPick);
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

  void onPostMessageChanged(String? value) {
    _postMessage = value;
    notifyListeners();
  }

  void openGallery(final int index) {
    AppRouter.rootNavigatorKey.currentState?.push(
      CupertinoPageRoute(
        builder: (context) => GalleryAssetPhotoView(
          loadingBuilder: (_, __) => Center(child: CircularProgressIndicator()),
          galleryItems: imageProvider.picked,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Future<void> postHandler() async {
    final service = context.read<LocalImageService>();
    final activities = context.read<Activities>();
    final user = context.read<Auth>().user!;

    var gallery = <LokalImages>[];
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

    try {
      await activities.post({
        'community_id': user.communityId,
        'user_id': user.id,
        'message': _postMessage,
        'images': gallery.map((x) => x.toMap()).toList(),
      });

      Navigator.pop(context, true);
    } catch (e) {
      showToast(e.toString());
    }
  }

  Future<bool> onWillPop(Widget displayMessage) async {
    if (_postMessage == null && imageProvider.picked.isEmpty) {
      return true;
    }
    final willPop = await showModalBottomSheet<bool>(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (ctx) => displayMessage,
    );
    return willPop ?? false;
  }
}
