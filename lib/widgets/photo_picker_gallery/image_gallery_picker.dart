import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../../routers/app_router.dart';
import '../../utils/constants/themes.dart';
import 'asset_gallery_widget.dart';
import 'custom_pick_asset_widget.dart';
import 'provider/custom_photo_provider.dart';

class ImageGalleryPicker extends StatelessWidget {
  final CustomPickerDataProvider provider; // can be inserted to provider
  final double pickerHeight;
  final double assetHeight;
  final double assetWidth;
  final bool enableSpecialItemBuilder;
  final WidgetBuilder? specialItemBuilder;
  final int thumbSize;

  const ImageGalleryPicker(
    this.provider, {
    this.pickerHeight = 100,
    this.assetHeight = 100,
    this.assetWidth = 100,
    this.thumbSize = 100, //100 pixels
    this.enableSpecialItemBuilder = false,
    this.specialItemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: AnimatedBuilder(
        animation: provider.currentPathNotifier,
        builder: (_, __) => _buildPath(),
      ),
    );
  }

  Widget _cameraPickerBuilder(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final AssetEntity? result = await CameraPicker.pickFromCamera(
          context,
          pickerConfig: CameraPickerConfig(
            textDelegate: EnglishCameraPickerTextDelegate(),
            onError: (e, stack) {
              AppRouter.rootNavigatorKey.currentState?.pop();
              if (e is CameraException) {
                if (e.code == 'cameraPermission') {
                  showToast('Denied camera permissions.');
                }
              }
            },
          ),
        );
        if (result != null) {
          provider.pickEntity(result);
        }
      },
      child: SizedBox(
        child: DecoratedBox(
          decoration: const BoxDecoration(color: kOrangeColor),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.camera_alt_outlined, size: 24, color: Colors.white),
                Text(
                  'Take a photo',
                  style: TextStyle(
                    fontFamily: 'Goldplay',
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPath() {
    return AssetGalleryWidget(
      path: provider.currentPath,
      assetHeight: assetHeight,
      assetWidth: assetWidth,
      thumbSize: thumbSize,
      loadWhenScrolling: true,
      specialItemBuilder: enableSpecialItemBuilder
          ? specialItemBuilder ?? _cameraPickerBuilder
          : null,
      buildItem: (context, asset, size) {
        return CustomPickAssetWidget(
          asset: asset,
          provider: provider,
          thumbSize: size,
        );
        // return AssetWidget(asset: asset);
      },
    );
  }
}
