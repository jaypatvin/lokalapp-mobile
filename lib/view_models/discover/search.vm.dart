import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/app_router.dart';
import '../../models/failure_exception.dart';
import '../../models/product.dart';
import '../../providers/auth.dart';
import '../../providers/products.dart';
import '../../services/api/api.dart';
import '../../services/api/search_api.dart';
import '../../state/view_model.dart';
import '../../utils/shared_preference.dart';

class SearchViewModel extends ViewModel {
  SearchViewModel();

  final TextEditingController searchController = TextEditingController();
  final SearchAPI _apiService = locator<SearchAPI>();

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  final List<Product> _searchResults = [];
  UnmodifiableListView<Product> get searchResults =>
      UnmodifiableListView(_searchResults);

  late List<String> _recentSearches;
  UnmodifiableListView<String> get recentSearches =>
      UnmodifiableListView(_recentSearches);

  late final String _userId;

  final _appRouter = locator<AppRouter>();

  @override
  void init() {
    _userId = context.read<Auth>().user!.id;
    _recentSearches =
        context.read<UserSharedPreferences>().getRecentSearches(_userId);
  }

  Future<void> onSubmitted(String query) async {
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
      context.read<UserSharedPreferences>().addRecentSearches(_userId, query);

      final response = await _apiService.search(
        query: query,
        communityId: context.read<Auth>().user!.communityId,
      );

      if (response['products']!.isEmpty) {
        throw FailureException(
          'no-results',
          'No search results. Refine or search for another.',
        );
      }

      for (final id in response['products']!) {
        final product = context.read<Products>().findById(id);
        if (product == null) continue;
        if (product.userId == context.read<Auth>().user!.id) continue;
        _searchResults.add(product);
      }

      _isSearching = false;
      notifyListeners();
    } on FailureException catch (e, stack) {
      if (e.message != 'no-results') {
        FirebaseCrashlytics.instance.recordError(e, stack);
        showToast(e.message);
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
    context
        .read<UserSharedPreferences>()
        .setRecentSearches(_userId, _recentSearches);
    notifyListeners();
  }

  void onRecentTap(int index) {
    searchController.text = _recentSearches[index];
    onSubmitted(searchController.text);
  }

  void onProductTap(int index) {
    final product = searchResults[index];
    _appRouter.navigateTo(
      AppRoute.discover,
      DiscoverRoutes.productDetail,
      arguments: ProductDetailArguments(product: product),
    );
  }
}
