import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

mixin PhotoDataProvider on ChangeNotifier {
  AssetPathEntity? _current;

  AssetPathEntity? get currentPath => _current;

  set currentPath(AssetPathEntity? current) {
    if (_current != current) {
      _current = current;
      currentPathNotifier.value = current;
    }
  }

  final currentPathNotifier = ValueNotifier<AssetPathEntity?>(null);

  final Map<String, PickerPathCache> _cacheMap = {};

  final pathListNotifier = ValueNotifier<List<AssetPathEntity>>([]);
  List<AssetPathEntity> pathList = [];

  static int _defaultSort(
    AssetPathEntity a,
    AssetPathEntity b,
  ) {
    if (a.isAll) {
      return -1;
    }
    if (b.isAll) {
      return 1;
    }
    return 0;
  }

  void resetPathList(
    List<AssetPathEntity> list, {
    int defaultIndex = 0,
    int Function(
      AssetPathEntity a,
      AssetPathEntity b,
    )
        sortBy = _defaultSort,
  }) {
    if (list.isEmpty) {
      clearPathList();
      return;
    }
    list.sort(sortBy);

    pathList.clear();
    pathList.addAll(list);
    _cacheMap.clear();
    currentPath = list[defaultIndex];
    pathListNotifier.value = pathList;
    notifyListeners();
  }

  void clearPathList() {
    pathList.clear();
    pathListNotifier.value = pathList;
    _cacheMap.clear();
    currentPath = null;
    notifyListeners();
  }

  PickerPathCache? getPickerCache(AssetPathEntity path) {
    final cache = _cacheMap[path.id];
    if (cache == null) {
      _cacheMap[path.id] = PickerPathCache(path: path);
    }
    return cache;
  }
}

class CustomPickerDataProvider extends ChangeNotifier with PhotoDataProvider {
  CustomPickerDataProvider({List<AssetPathEntity>? pathList, int max = 9}) {
    if (pathList != null && pathList.isNotEmpty) {
      this.pathList.addAll(pathList);
    }
    pickedNotifier.value = picked;
    maxNotifier.value = max;
  }

  /// Notification when max is modified.
  final maxNotifier = ValueNotifier(0);

  int get max => maxNotifier.value;
  set max(int value) => maxNotifier.value = value;

  final onPickMax = ChangeNotifier();

  /// The currently selected item.
  List<AssetEntity> picked = [];

  final isOriginNotifier = ValueNotifier(false);

  bool get isOrigin => isOriginNotifier.value;

  set isOrigin(bool isOrigin) {
    isOriginNotifier.value = isOrigin;
  }

  /// Single-select mode, there are subtle differences between interaction and multiple selection.
  ///
  /// In single-select mode, when you click an unselected item, the old one is automatically cleared and the new one is selected.
  bool get singlePickMode => _singlePickMode;
  bool _singlePickMode = false;
  set singlePickMode(bool singlePickMode) {
    _singlePickMode = singlePickMode;
    if (singlePickMode) {
      maxNotifier.value = 1;
    }
  }

  final pickedNotifier = ValueNotifier<List<AssetEntity>>([]);

  void pickEntity(AssetEntity entity) {
    if (singlePickMode) {
      if (picked.contains(entity)) {
        picked.remove(entity);
      } else {
        picked.clear();
        picked.add(entity);
      }
    } else {
      if (picked.contains(entity)) {
        picked.remove(entity);
      } else {
        if (picked.length == max) {
          onPickMax.notifyListeners();
          return;
        }
        picked.add(entity);
      }
    }
    pickedNotifier.value = picked;
    pickedNotifier.notifyListeners();
    notifyListeners();
  }

  void removeAt(int index) {
    if (picked.isEmpty) return;
    pickEntity(picked[index]);
  }

  int pickIndex(AssetEntity entity) {
    return picked.indexOf(entity);
  }
}

class PickerPathCache {
  final AssetPathEntity path;

  Map<int, AssetEntity> map = {};

  PickerPathCache({
    required this.path,
  });

  void cache(int index, AssetEntity entity) {
    map[index] = entity;
  }

  AssetEntity? entity(int index) {
    return map[index];
  }
}
