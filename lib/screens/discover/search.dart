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
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Recent Searches',
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Goldplay',
              fontWeight: FontWeight.w600,
              color: kNavyColor,
            ),
          ),
        ),
      );
    });

    final _recentSearchesList = useMemoized(() {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx2, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFF2F2F2),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: GestureDetector(
                      onTap: () => vm.onRecentTap(index),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            vm.recentSearches[index],
                            style:
                                Theme.of(context).textTheme.bodyText2?.copyWith(
                                      color: const Color(0xFF828282),
                                      fontWeight: FontWeight.w400,
                                    ),
                          ),
                          GestureDetector(
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: kTealColor,
                            ),
                            onTap: () => vm.onSearchDelete(index),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
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
              slivers: [
                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
                _recentSearchesLabel,
                _recentSearchesList
              ],
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
                  child: Text(
                    '${vm.searchResults.length} '
                    'result${vm.searchResults.length == 1 ? '' : 's'} for '
                    "'${vm.searchController.text}'",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(color: Colors.black),
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
                )
              else ...[
                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
                _recentSearchesLabel,
                _recentSearchesList,
              ],
              // if (vm.searchResults.isEmpty) _recentSearchesLabel,
              // if (vm.searchResults.isEmpty) _recentSearchesList,
            ],
          );
        },
      ),
    );
  }
}
