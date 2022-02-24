import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  const Discover({Key? key}) : super(key: key);

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
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (ctx, index) {
            return SizedBox(
              width: 100.0.w,
              child: Column(
                children: [
                  // TODO: separate widget
                  Container(
                    height: 70.0.r,
                    width: 70.0.r,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0XFFF1FAFF),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0.r),
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
                  SizedBox(height: 10.0.h),
                  Text(
                    categories[index].name,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(ctx)
                        .textTheme
                        .subtitle2
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
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
          onRefresh: () async {
            await context.read<Products>().fetch();
            await vm.fetchRecommendedProducts();
          },
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
                    child: SizedBox(height: 10.0.h),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                    child: SizedBox(height: 10.0.h),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: Text(
                        'Recommended',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 5.0.h)),
                  if (vm.isLoading)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 250.0.h,
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
                    )
                  else
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 250.0.h,
                        width: MediaQuery.of(context).size.width,
                        child: _RecommendedProducts(
                          products: vm.recommendedProducts,
                          onProductTap: vm.onProductTap,
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(child: SizedBox(height: 15.0.h)),
                  SliverToBoxAdapter(
                    child: Divider(
                      color: Colors.grey.shade300,
                      indent: 16.0.w,
                      endIndent: 16.0.w,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0.w,
                        vertical: 10.0.h,
                      ),
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
                                      .subtitle1
                                      ?.copyWith(color: kTealColor),
                                ),
                                Icon(
                                  // Icons.arrow_forward_ios,
                                  Icons.arrow_forward,
                                  color: kTealColor,
                                  size: 16.0.sp,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 130.0.h,
                      child: _buildCategories(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Divider(
                      color: Colors.grey.shade300,
                      indent: 16.0.w,
                      endIndent: 16.0.w,
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 10.0.h)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: Text(
                        'Recent',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
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
                    ProductsSliverGrid(
                      items: vm.otherUserProducts,
                      onProductTap: vm.onProductTap,
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
    Key? key,
    required this.products,
    required this.onProductTap,
  }) : super(key: key);

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
      scrollDirection: Axis.horizontal,
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 5 / 3.5,
        crossAxisCount: 1,
      ),
      itemBuilder: (ctx, index) {
        return Container(
          key: Key(products[index].id),
          padding: index == 0
              ? EdgeInsets.only(left: 16.0.w, right: 2.5.w)
              : index == products.length - 1
                  ? EdgeInsets.only(left: 2.5.w, right: 16.0.w)
                  : EdgeInsets.symmetric(horizontal: 2.5.w),
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
