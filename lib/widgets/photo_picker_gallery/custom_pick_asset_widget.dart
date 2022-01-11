import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'custom_asset_widget.dart';
import 'pick/pick_checkbox.dart';
import 'pick/pick_color_mask.dart';
import 'provider/custom_photo_provider.dart';

class CustomPickAssetWidget extends StatelessWidget {
  final AssetEntity asset;
  final int thumbSize;
  final CustomPickerDataProvider? provider;
  final Function? onTap;
  final PickColorMaskBuilder? pickColorMaskBuilder;
  final PickedCheckboxBuilder? pickedCheckboxBuilder;

  const CustomPickAssetWidget({
    Key? key,
    required this.asset,
    required this.provider,
    this.thumbSize = 100,
    this.onTap,
    this.pickColorMaskBuilder = PickColorMask.buildWidget,
    this.pickedCheckboxBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pickMask = AnimatedBuilder(
      animation: provider!,
      builder: (_, __) {
        final pickIndex = provider!.pickIndex(asset);
        final picked = pickIndex >= 0;
        return pickColorMaskBuilder?.call(context, picked) ??
            PickColorMask(
              picked: picked,
            );
      },
    );

    final checkWidget = AnimatedBuilder(
      animation: provider!,
      builder: (_, __) {
        final pickIndex = provider!.pickIndex(asset);
        return pickedCheckboxBuilder?.call(context, pickIndex) ??
            PickedCheckbox(
              onClick: () {
                provider!.pickEntity(asset);
              },
              checkIndex: pickIndex,
            );
      },
    );

    if (asset.type == AssetType.video) {
      // do nothing
    }

    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Hero(
              tag: asset,
              child: CustomAssetWidget(
                asset: asset,
                thumbSize: thumbSize,
              ),
            ),
          ),
          pickMask,
          checkWidget,
        ],
      ),
    );
  }
}
