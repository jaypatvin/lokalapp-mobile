import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:oktoast/oktoast.dart';

import '../app/app.locator.dart';
import '../app/app.router.dart';
import '../app/app_router.dart';
import '../models/lokal_category.dart';
import '../services/database/collections/categories.collection.dart';
import '../services/database/database.dart';

class Categories extends ChangeNotifier {
  Categories(Database database) : _db = database.categories;

  final CategoriesCollection _db;

  List<LokalCategory> _categories = [];

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  UnmodifiableListView<LokalCategory> get categories =>
      UnmodifiableListView(_categories);

  Future<void> fetch() async {
    try {
      _isLoading = true;
      notifyListeners();

      _categories = await _db.getCategories();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      showToast(e.toString());
      // don't do anything
    }
  }

  String getCategoryId(String name) {
    return _categories.firstWhere((category) => category.name == name).id;
  }

  void onCategoryTap(int index) {
    final _category = _categories[index];

    locator<AppRouter>().navigateTo(
      AppRoute.discover,
      DiscoverRoutes.categoriesLanding,
      arguments: CategoriesLandingArguments(category: _category),
    );
  }
}
