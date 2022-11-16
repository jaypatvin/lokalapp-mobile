import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../models/product.dart';
import '../../providers/categories.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../state/mvvm_builder.widget.dart';
import '../../state/views/stateless.view.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/discover/discover.vm.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/inputs/search_text_field.dart';
import '../../widgets/products_sliver_grid.dart';
import '../cart/cart_container.dart';
import '../profile/components/product_card.dart';

class Discover extends StatelessWidget {
  static const routeName = '/discover';
  const Discover({super.key});

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _DiscoverView(),
      viewModel: DiscoverViewModel(),
    );
  }
}

class _DiscoverView extends StatelessView<DiscoverViewModel> {
  Widget _buildCategories() {
    return Consumer<Categories>(
      builder: (ctx, provider, _) {
        if (provider.isLoading) {
          return Shimmer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: kOrangeColor,
                ),
              ),
            ),
          );
        }
        final categories = provider.categories;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (ctx, index) => const SizedBox(width: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (ctx, index) {
            return SizedBox(
              width: 70,
              child: GestureDetector(
                onTap: () => provider.onCategoryTap(index),
                child: Column(
                  children: [
                    // TODO: separate widget
                    Container(
                      height: 70.0,
                      width: 70.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0XFFF1FAFF),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: CachedNetworkImage(
                          imageUrl: categories[index].iconUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Shimmer(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          errorWidget: (ctx, url, err) {
                            if (categories[index].iconUrl.isEmpty) {
                              return const Center(child: Text('No image.'));
                            }
                            return const Center(
                              child: Text('Error displaying image.'),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      categories[index].name,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(ctx).textTheme.subtitle2?.copyWith(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget render(BuildContext context, DiscoverViewModel vm) {
    return Scaffold(
      appBar: const CustomAppBar(
        titleText: 'Discover',
        backgroundColor: kOrangeColor,
        buildLeading: false,
      ),
      body: CartContainer(
        alwaysDisplayButton: true,
        child: RefreshIndicator(
          onRefresh: vm.fetchRecommendedProducts,
          child: Consumer2<Shops, Products>(
            builder: (ctx, shops, products, _) {
              if (shops.isLoading || products.isLoading) {
                return SizedBox.expand(
                  child: Lottie.asset(kAnimationLoading, fit: BoxFit.cover),
                );
              }
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 30,
                      ),
                      child: GestureDetector(
                        onTap: vm.onSearch,
                        child: const Hero(
                          tag: 'search_field',
                          child: SearchTextField(),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Recommended',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  if (vm.isLoading)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 223,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Shimmer(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: kOrangeColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 223,
                        width: MediaQuery.of(context).size.width,
                        child: _RecommendedProducts(
                          key: const Key('recommended_products'),
                          products: vm.recommendedProducts,
                          onProductTap: vm.onProductTap,
                        ),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            'Explore Categories',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: vm.onExploreCategories,
                            child: Row(
                              children: [
                                Text(
                                  'View All',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      ?.copyWith(color: kTealColor),
                                ),
                                const Icon(
                                  Icons.arrow_forward,
                                  color: kTealColor,
                                  size: 16.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 110,
                      child: _buildCategories(),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 30)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Recent',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  if (vm.isProductsLoading)
                    SliverFillRemaining(
                      child: Center(
                        child: Lottie.asset(
                          kAnimationLoading,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      sliver: ProductsSliverGrid(
                        items: vm.otherUserProducts,
                        onProductTap: vm.onProductTap,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RecommendedProducts extends StatelessWidget {
  const _RecommendedProducts({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  final List<Product> products;
  final void Function(String) onProductTap;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text('There are currently no products yet.'),
      );
    }

    return GridView.builder(
      key: const Key('recommended_gridview_builder'),
      scrollDirection: Axis.horizontal,
      itemCount: products.length,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 5 / 3,
        crossAxisCount: 1,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (ctx, index) {
        return SizedBox(
          key: Key(products[index].id),
          child: GestureDetector(
            key: Key(products[index].id),
            onTap: () => onProductTap(products[index].id),
            child: ProductCard(products[index].id),
          ),
        );
      },
    );
  }
}
