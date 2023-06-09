import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

typedef Widget AssetWidgetBuilder(
  BuildContext context,
  AssetEntity asset,
  int thumbSize,
);

class CustomAssetWidget extends StatelessWidget {
  final AssetEntity asset;
  final int thumbSize;

  const CustomAssetWidget({
    Key key,
    @required this.asset,
    this.thumbSize = 100,
  }) : super(key: key);

  static CustomAssetWidget buildWidget(
      BuildContext context, AssetEntity asset, int thumbSize) {
    return CustomAssetWidget(
      asset: asset,
      thumbSize: thumbSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (asset.type == AssetType.video) {
      return Container(
        foregroundDecoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
        ),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image(
                  image: AssetEntityThumbImage(
                    entity: asset,
                    width: thumbSize,
                    height: thumbSize,
                  ),
                  fit: BoxFit.cover),
            ),
            ColoredBox(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Icon(
                  Icons.video_library,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      foregroundDecoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
      ),
      child: Image(
        image: AssetEntityThumbImage(
          entity: asset,
          width: thumbSize,
          height: thumbSize,
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}

class AssetBigPreviewWidget extends StatelessWidget {
  final AssetEntity asset;

  const AssetBigPreviewWidget({
    Key key,
    @required this.asset,
  }) : super(key: key);

  static CustomAssetWidget buildWidget(
      BuildContext context, AssetEntity asset, int thumbSize) {
    return CustomAssetWidget(
      asset: asset,
      thumbSize: thumbSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetEntityFileImage(asset),
      fit: BoxFit.cover,
    );
  }
}

class AssetEntityFileImage extends ImageProvider<AssetEntityFileImage> {
  final AssetEntity entity;
  final double scale;

  const AssetEntityFileImage(
    this.entity, {
    this.scale = 1.0,
  });

  @override
  ImageStreamCompleter load(AssetEntityFileImage key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
    );
  }

  Future<ui.Codec> _loadAsync(
      AssetEntityFileImage key, DecoderCallback decode) async {
    assert(key == this);
    final bytes = (await entity.file).readAsBytesSync();
    return decode(bytes);
  }

  @override
  Future<AssetEntityFileImage> obtainKey(
      ImageConfiguration configuration) async {
    return this;
  }

  bool operator ==(other) {
    if (identical(other, this)) {
      return true;
    }
    if (other is! AssetEntityFileImage) {
      return false;
    }
    final AssetEntityFileImage o = other;
    return o.entity == entity && o.scale == this.scale;
  }

  @override
  int get hashCode => hashValues(entity, scale);
}

class AssetEntityThumbImage extends ImageProvider<AssetEntityThumbImage> {
  final AssetEntity entity;
  final int width;
  final int height;
  final double scale;

  AssetEntityThumbImage({
    @required this.entity,
    int width,
    int height,
    this.scale = 1.0,
  })  : width = width ?? entity.width,
        height = height ?? entity.height;

  @override
  ImageStreamCompleter load(AssetEntityThumbImage key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
    );
  }

  Future<ui.Codec> _loadAsync(
      AssetEntityThumbImage key, DecoderCallback decode) async {
    assert(key == this);
    final bytes = await entity.thumbDataWithSize(width, height);
    return decode(bytes);
  }

  @override
  Future<AssetEntityThumbImage> obtainKey(
      ImageConfiguration configuration) async {
    return this;
  }

  bool operator ==(other) {
    if (identical(other, this)) {
      return true;
    }
    if (other is! AssetEntityThumbImage) {
      return false;
    }
    final AssetEntityThumbImage o = other;
    return (o.entity == entity &&
        o.scale == scale &&
        o.width == width &&
        o.height == height);
  }

  @override
  int get hashCode => hashValues(entity, scale, width, height);
}
