import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import 'asset_gallery_widget.dart';
import 'custom_pick_asset_widget.dart';
import 'provider/custom_photo_provider.dart';

class ImageGalleryPicker extends StatelessWidget {
  final CustomPickerDataProvider? provider; // can be inserted to provider
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
        animation: provider!.currentPathNotifier,
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
          // maximumRecordingDuration: const Duration(seconds: 30),
          // textDelegate: EnglishCameraPickerTextDelegateWithRecording(),
          textDelegate: EnglishCameraPickerTextDelegate(),
        );
        if (result != null) {
          ///Navigator.of(context).pop(<AssetEntity>[...assets, result]);
          provider!.picked = [...provider!.picked, result];
        }
      },
      child: const Center(
        child: Icon(MdiIcons.camera, size: 42.0),
      ),
    );
  }

  Widget _buildPath() {
    return AssetGalleryWidget(
      path: provider?.currentPath,
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
