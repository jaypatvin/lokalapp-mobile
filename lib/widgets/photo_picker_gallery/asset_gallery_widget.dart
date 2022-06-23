import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'asset_widget.dart';

typedef AssetPathWidgetBuilder = Widget Function(
  BuildContext context,
  AssetPathEntity path,
);

typedef OnAssetItemClick = void Function(
  BuildContext context,
  AssetEntity entity,
  int index,
);

class AssetGalleryWidget extends StatefulWidget {
  final AssetPathEntity? path;
  final AssetWidgetBuilder buildItem;
  final int thumbSize;
  final Widget scrollingWidget;
  final bool loadWhenScrolling;
  final OnAssetItemClick? onAssetItemClick;
  final double assetHeight;
  final double assetWidth;
  final WidgetBuilder? specialItemBuilder;

  const AssetGalleryWidget({
    Key? key,
    required this.path,
    this.buildItem = AssetWidget.buildWidget,
    this.thumbSize = 100,
    this.scrollingWidget = const _ScrollingWidget(),
    this.onAssetItemClick,
    this.loadWhenScrolling = false,
    this.assetHeight = 100,
    this.assetWidth = 100,
    this.specialItemBuilder,
  }) : super(key: key);

  @override
  _AssetGalleryWidgetState createState() => _AssetGalleryWidgetState();
}

class _AssetGalleryWidgetState extends State<AssetGalleryWidget> {
  static Map<int, AssetEntity> _createMap() {
    return {};
  }

  final cacheMap = _createMap();
  final scrolling = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    int itemCount = widget.path?.assetCount ?? 0;
    if (widget.specialItemBuilder != null) {
      itemCount += 1;
    }

    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: ListView.separated(
        key: ValueKey(widget.path),
        separatorBuilder: (ctx, index) => const SizedBox(width: 8),
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) => SizedBox(
          height: widget.assetHeight,
          width: widget.assetWidth,
          child: _buildItem(context, index),
        ),
      ),
    );
  }

  Widget _buildScrollItem(BuildContext context, int index) {
    final asset = cacheMap[index];
    if (asset != null) {
      return widget.buildItem(context, asset, widget.thumbSize);
    } else {
      return FutureBuilder<List<AssetEntity>>(
        initialData: const [],
        future: widget.path?.getAssetListRange(start: index, end: index + 1),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return widget.scrollingWidget;
          }
          final asset = snapshot.data![0];
          if (asset.type == AssetType.video) {}
          cacheMap[index] = asset;
          return widget.buildItem(context, asset, widget.thumbSize);
        },
      );
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    int currentIndex;
    if (widget.specialItemBuilder != null) {
      currentIndex = index - 1;
    } else {
      currentIndex = index;
    }

    if (index == 0 && widget.specialItemBuilder != null) {
      return widget.specialItemBuilder!(context);
    }

    if (widget.loadWhenScrolling) {
      return GestureDetector(
        onTap: () async {
          var asset = cacheMap[currentIndex];
          if (asset == null) {
            asset = (await widget.path!.getAssetListRange(
              start: currentIndex,
              end: currentIndex + 1,
            ))[0];
            cacheMap[currentIndex] = asset;
          }
          widget.onAssetItemClick?.call(context, asset, currentIndex);
        },
        child: _buildScrollItem(context, currentIndex),
      );
    }
    return GestureDetector(
      onTap: () async {
        var asset = cacheMap[currentIndex];
        if (asset == null) {
          asset = (await widget.path!.getAssetListRange(
            start: currentIndex,
            end: currentIndex + 1,
          ))[0];
          cacheMap[currentIndex] = asset;
        }
        widget.onAssetItemClick?.call(context, asset, currentIndex);
      },
      child: _WrapItem(
        cacheMap: cacheMap,
        path: widget.path,
        index: currentIndex,
        onLoaded: (AssetEntity entity) {
          cacheMap[currentIndex] = entity;
        },
        buildItem: widget.buildItem,
        loaded: cacheMap.containsKey(currentIndex),
        thumbSize: widget.thumbSize,
        valueNotifier: scrolling,
        scrollingPlaceHolder: widget.scrollingWidget,
        entity: cacheMap[currentIndex],
      ),
    );
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      scrolling.value = false;
    } else if (notification is ScrollStartNotification) {
      scrolling.value = true;
    }
    return false;
  }

  @override
  void didUpdateWidget(AssetGalleryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      cacheMap.clear();
      scrolling.value = false;
      if (mounted) {
        setState(() {});
      }
    }
  }
}

class _WrapItem extends StatefulWidget {
  final AssetPathEntity? path;
  final int index;
  final void Function(AssetEntity entity) onLoaded;
  final ValueNotifier<bool> valueNotifier;
  final bool loaded;
  final AssetWidgetBuilder buildItem;
  final int thumbSize;
  final Widget scrollingPlaceHolder;
  final AssetEntity? entity;
  final Map<int, AssetEntity>? cacheMap;
  const _WrapItem({
    Key? key,
    required this.path,
    required this.index,
    required this.onLoaded,
    required this.valueNotifier,
    required this.loaded,
    required this.buildItem,
    required this.thumbSize,
    required this.scrollingPlaceHolder,
    required this.entity,
    this.cacheMap,
  }) : super(key: key);

  @override
  __WrapItemState createState() => __WrapItemState();
}

class __WrapItemState extends State<_WrapItem> {
  bool get scrolling => widget.valueNotifier.value;

  bool _loaded = false;

  bool get loaded => _loaded || widget.loaded;
  AssetEntity? assetEntity;

  @override
  void initState() {
    super.initState();
    assetEntity = widget.cacheMap![widget.index];
    widget.valueNotifier.addListener(onChange);
    if (!scrolling) {
      _load();
    }
  }

  void onChange() {
    if (assetEntity != null) {
      return;
    }
    if (loaded) {
      return;
    }
    if (scrolling) {
      return;
    }
    _load();
  }

  @override
  void dispose() {
    widget.valueNotifier.removeListener(onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (assetEntity == null) {
      return widget.scrollingPlaceHolder;
    }
    return widget.buildItem(context, assetEntity!, widget.thumbSize);
  }

  Future<void> _load() async {
    final list = await widget.path!
        .getAssetListRange(start: widget.index, end: widget.index + 1);
    if (list.isNotEmpty) {
      final asset = list[0];
      _loaded = true;
      widget.onLoaded(asset);
      assetEntity = asset;
      if (mounted) {
        setState(() {});
      }
    }
  }
}

class _ScrollingWidget extends StatelessWidget {
  const _ScrollingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xFF4A4748),
        ),
      ),
    );
  }
}
