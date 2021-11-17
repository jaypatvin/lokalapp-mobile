import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/auth.dart';
import '../../providers/products.dart';
import '../../routers/app_router.dart';
import '../../routers/discover/product_detail.props.dart';
import '../../screens/discover/product_detail.dart';
import '../../services/api/api.dart';
import '../../services/api/search_api_service.dart';
import '../../utils/shared_preference.dart';

class SearchViewModel extends ChangeNotifier {
  SearchViewModel(this.context);

  final BuildContext context;
  final TextEditingController searchController = TextEditingController();

  late final SearchAPIService _apiService;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  List<Product> _searchResults = [];
  UnmodifiableListView<Product> get searchResults =>
      UnmodifiableListView(_searchResults);

  late List<String> _recentSearches;
  UnmodifiableListView<String> get recentSearches =>
      UnmodifiableListView(_recentSearches);

  Timer? _timer;

  void init() {
    _apiService = SearchAPIService(context.read<API>());
    _recentSearches = context.read<UserSharedPreferences>().getRecentSearches();
  }

  void onChanged(String text) {
    _timer?.cancel();
    this._timer = Timer(
      const Duration(milliseconds: 750),
      () => _performSearch(text),
    );
  }

  void _performSearch(String query) async {
    if (query.isEmpty) return;

    _isSearching = true;
    _recentSearches.insert(0, query);
    _searchResults.clear();

    notifyListeners();

    try {
      context.read<UserSharedPreferences>().addRecentSearches(query);

      final response = await _apiService.search(
        query: query,
        communityId: context.read<Auth>().user!.communityId!,
      );

      if (response['products']!.isEmpty) {
        throw ('Result is empty');
      }

      for (final id in response['products']!) {
        final product = context.read<Products>().findById(id);
        if (product == null) continue;
        _searchResults.add(product);
      }

      _isSearching = false;
      notifyListeners();
    } catch (e) {
      _isSearching = false;
      notifyListeners();
      _showError(e.toString());
    }
  }

  void onSearchDelete(int index) {
    _recentSearches.removeAt(index);
    context.read<UserSharedPreferences>().setRecentSearches(_recentSearches);
    notifyListeners();
  }

  void onProductTap(int index) {
    final product = searchResults[index];
    context.read<AppRouter>()
      ..navigateTo(
        AppRoute.discover,
        ProductDetail.routeName,
        arguments: ProductDetailProps(product),
      );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
