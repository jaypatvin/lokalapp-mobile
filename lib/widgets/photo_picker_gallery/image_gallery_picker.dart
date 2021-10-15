import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photo_manager/photo_manager.dart';
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

  ImageGalleryPicker(
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
        animation: this.provider!.currentPathNotifier,
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
          enableRecording: false,
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
    if (this.provider!.currentPath == null) {
      return Container();
    }
    return AssetGalleryWidget(
      path: this.provider!.currentPath,
      assetHeight: this.assetHeight,
      assetWidth: this.assetWidth,
      thumbSize: this.thumbSize,
      loadWhenScrolling: true,
      specialItemBuilder: this.enableSpecialItemBuilder
          ? specialItemBuilder ?? _cameraPickerBuilder
          : null,
      buildItem: (context, asset, size) {
        return CustomPickAssetWidget(
          asset: asset,
          provider: this.provider,
          thumbSize: size,
        );
        // return AssetWidget(asset: asset);
      },
    );
  }
}
