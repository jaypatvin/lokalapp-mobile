import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../models/failure_exception.dart';
import '../../models/product.dart';
import '../../providers/auth.dart';
import '../../providers/products.dart';
import '../../routers/app_router.dart';
import '../../routers/discover/product_detail.props.dart';
import '../../screens/discover/product_detail.dart';
import '../../services/api/api.dart';
import '../../services/api/search_api_service.dart';
import '../../state/view_model.dart';
import '../../utils/shared_preference.dart';

class SearchViewModel extends ViewModel {
  SearchViewModel();

  final TextEditingController searchController = TextEditingController();

  late final SearchAPIService _apiService;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  final List<Product> _searchResults = [];
  UnmodifiableListView<Product> get searchResults =>
      UnmodifiableListView(_searchResults);

  late List<String> _recentSearches;
  UnmodifiableListView<String> get recentSearches =>
      UnmodifiableListView(_recentSearches);

  Timer? _timer;

  @override
  void init() {
    _apiService = SearchAPIService(context.read<API>());
    _recentSearches = context.read<UserSharedPreferences>().getRecentSearches();
  }

  /// Will perform the search every 750ms
  void onChanged({
    required String text,
    Duration duration = const Duration(milliseconds: 750),
  }) {
    _timer?.cancel();
    _timer = Timer(
      duration,
      () => _performSearch(text),
    );
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      _searchResults.clear();
      notifyListeners();
      return;
    }

    _isSearching = true;
    if (!_recentSearches.contains(query)) _recentSearches.insert(0, query);
    _searchResults.clear();

    notifyListeners();

    try {
      context.read<UserSharedPreferences>().addRecentSearches(query);

      final response = await _apiService.search(
        query: query,
        communityId: context.read<Auth>().user!.communityId!,
      );

      if (response['products']!.isEmpty) {
        throw 'No search results. Refine or search for another.';
      }

      for (final id in response['products']!) {
        final product = context.read<Products>().findById(id);
        if (product == null) continue;
        if (product.userId == context.read<Auth>().user!.id) continue;
        _searchResults.add(product);
      }

      _isSearching = false;
      notifyListeners();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
      _isSearching = false;
      notifyListeners();
    }
  }

  void onSearchDelete(int index) {
    _recentSearches.removeAt(index);
    context.read<UserSharedPreferences>().setRecentSearches(_recentSearches);
    notifyListeners();
  }

  void onRecentTap(int index) {
    searchController.text = _recentSearches[index];
    _performSearch(searchController.text);
  }

  void onProductTap(int index) {
    final product = searchResults[index];
    context.read<AppRouter>().navigateTo(
          AppRoute.discover,
          ProductDetail.routeName,
          arguments: ProductDetailProps(product),
        );
  }
}
