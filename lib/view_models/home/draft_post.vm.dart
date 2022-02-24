import 'dart:io' show Platform;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../models/app_navigator.dart';
import '../../models/failure_exception.dart';
import '../../models/lokal_images.dart';
import '../../providers/activities.dart';
import '../../providers/auth.dart';
import '../../routers/app_router.dart';
import '../../services/local_image_service.dart';
import '../../state/view_model.dart';
import '../../utils/constants/assets.dart';
import '../../widgets/photo_picker_gallery/provider/custom_photo_provider.dart';
import '../../widgets/photo_view_gallery/gallery/gallery_asset_photo_view.dart';

class DraftPostViewModel extends ViewModel {
  DraftPostViewModel();
  late final CustomPickerDataProvider imageProvider;

  String? _postMessage;
  String? get postMessage => _postMessage;

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
  }

  @override
  void dispose() {
    imageProvider.picked.clear();
    imageProvider.removeListener(_showMaxAssetsText);
    imageProvider.pickedNotifier.removeListener(_onPick);
    super.dispose();
  }

  Future<void> onShowImagePicker({
    Future<void> Function()? iOSDialogPermissionCallback,
  }) async {
    if (!_showImagePicker) {
      final result = await PhotoManager.requestPermissionExtend();
      if (result.isAuth) {
        // TODO: check if this is necessary on iOS
        if (result == PermissionState.limited) {
          iOSDialogPermissionCallback?.call();
        }
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

  void onPostMessageChanged(String? value) {
    _postMessage = value;
    notifyListeners();
  }

  void openGallery(final int index) {
    AppRouter.rootNavigatorKey.currentState?.push(
      AppNavigator.appPageRoute(
        builder: (_) => GalleryAssetPhotoView(
          initialIndex: index,
          galleryItems: imageProvider.picked,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          loadingBuilder: (_, __) =>
              const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Future<void> postHandler() async {
    final service = context.read<LocalImageService>();
    final activities = context.read<Activities>();
    final user = context.read<Auth>().user!;

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

    try {
      await activities.post({
        'community_id': user.communityId,
        'user_id': user.id,
        'message': _postMessage,
        'images': gallery.map((x) => x.toMap()).toList(),
      });

      Navigator.pop(context, true);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
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
