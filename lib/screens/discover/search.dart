import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            'Recent Searches',
            style: TextStyle(
              fontSize: 20.0.sp,
              fontFamily: 'Goldplay',
              fontWeight: FontWeight.bold,
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
            enabled: true,
            onChanged: (searchTerm) => vm.onChanged(text: searchTerm),
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
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${vm.searchResults.length} results for '
                    "'${vm.searchController.text}'",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              if (vm.searchResults.isNotEmpty)
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) {
                      try {
                        return Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 5.0.h,
                            horizontal: 2.5.w,
                          ),
                          child: GestureDetector(
                            onTap: () => vm.onProductTap(index),
                            child: ProductCard(vm.searchResults[index].id),
                          ),
                        );
                      } catch (e) {
                        return const SizedBox();
                      }
                    },
                    childCount: vm.searchResults.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 2 / 3,
                    crossAxisCount: 2,
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
