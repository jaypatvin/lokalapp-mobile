import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../models/lokal_category.dart';
import '../services/api/api.dart';
import '../services/api/category_api_service.dart';

class Categories extends ChangeNotifier {
  Categories({this.api});

  List<LokalCategory> _categories = [];

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  API? api;

  void setAPI(API api) {
    this.api = api;
  }

  UnmodifiableListView<LokalCategory> get categories =>
      UnmodifiableListView(_categories);

  Future<void> fetch() async {
    _isLoading = true;
    notifyListeners();

    final _service = CategoryAPIService(api!);

    _categories = await _service.getAll();
    _isLoading = false;
    notifyListeners();
  }

  String getCategoryId(String name) {
    return _categories.firstWhere((category) => category.name == name).id;
  }
}
