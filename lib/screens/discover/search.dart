import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';

import '../../state/mvvm_builder.widget.dart';
import '../../state/views/hook.view.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/discover/search.vm.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/inputs/search_text_field.dart';
import '../profile/components/product_card.dart';

class Search extends StatelessWidget {
  static const routeName = '/discover/search';
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _SearchView(),
      viewModel: SearchViewModel(),
    );
  }
}

class _SearchView extends HookView<SearchViewModel> {
  @override
  Widget render(BuildContext context, SearchViewModel vm) {
    final _recentSearchesLabel = useMemoized(() {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'Recent Searches',
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Goldplay',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      );
    });

    final _recentSearchesList = useMemoized(() {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx2, index) {
            return ListTile(
              onTap: () => vm.onRecentTap(index),
              title: Text(vm.recentSearches[index]),
              trailing: IconButton(
                onPressed: () => vm.onSearchDelete(index),
                icon: const Icon(Icons.close),
              ),
            );
          },
          childCount: vm.recentSearches.length,
        ),
      );
    }, [
      vm.recentSearches,
    ]);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        leadingColor: kTealColor,
        backgroundColor: Colors.white,
        title: Hero(
          tag: 'search_field',
          child: SearchTextField(
            controller: vm.searchController,
            onSubmitted: vm.onSubmitted,
            enabled: true,
          ),
        ),
        onPressedLeading: () => Navigator.of(context).pop(),
      ),
      body: Builder(
        builder: (_) {
          if (vm.isSearching) {
            return Center(
              child: LottieBuilder.asset(
                kAnimationLoading,
                fit: BoxFit.cover,
                repeat: true,
              ),
            );
          }

          if (vm.searchController.text.isEmpty) {
            return CustomScrollView(
              slivers: [_recentSearchesLabel, _recentSearchesList],
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 11),
                  child: Text(
                    '${vm.searchResults.length} results for '
                    "'${vm.searchController.text}'",
                    style: Theme.of(context).textTheme.subtitle2?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              if (vm.searchResults.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (_, index) {
                        try {
                          return GestureDetector(
                            onTap: () => vm.onProductTap(index),
                            child: ProductCard(vm.searchResults[index].id),
                          );
                        } catch (e, stack) {
                          FirebaseCrashlytics.instance.recordError(e, stack);
                          return const SizedBox();
                        }
                      },
                      childCount: vm.searchResults.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 2 / 3,
                      crossAxisCount: 2,
                      mainAxisSpacing: 7,
                      crossAxisSpacing: 8,
                    ),
                  ),
                ),
              if (vm.searchResults.isEmpty) _recentSearchesLabel,
              if (vm.searchResults.isEmpty) _recentSearchesList,
            ],
          );
        },
      ),
    );
  }
}
