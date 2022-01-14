import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/categories.dart';
import '../../state/mvvm_builder.widget.dart';
import '../../state/views/stateless.view.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/discover/discover.vm.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/inputs/search_text_field.dart';
import '../../widgets/products_list.dart';
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
          return const Center(
            child: CircularProgressIndicator(),
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
                  CircleAvatar(
                    radius: 35.0.r,
                    backgroundColor: const Color(0XFFF1FAFF),
                    foregroundImage: NetworkImage(categories[index].iconUrl),
                    onForegroundImageError: (obj, stack) {},
                  ),
                  SizedBox(height: 10.0.h),
                  Text(
                    categories[index].name,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(ctx).textTheme.subtitle1,
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
          onRefresh: vm.fetchRecommendedProducts,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0.h),
                GestureDetector(
                  onTap: vm.onSearch,
                  child: const Hero(
                    tag: 'search_field',
                    child: SearchTextField(),
                  ),
                ),
                SizedBox(height: 10.0.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  child: Text(
                    'Recommended',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                SizedBox(height: 5.0.h),
                if (vm.isLoading)
                  Center(
                    child: Lottie.asset(
                      kAnimationLoading,
                      fit: BoxFit.contain,
                    ),
                  ),
                if (!vm.isLoading)
                  _RecommendedProducts(
                    products: vm.recommendedProducts,
                    onProductTap: vm.onProductTap,
                  ),

                SizedBox(height: 15.0.h),
                Divider(
                  color: Colors.grey.shade300,
                  indent: 16.0.w,
                  endIndent: 16.0.w,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  child: Row(
                    children: [
                      Text(
                        'Explore Categories',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: vm.onExploreCategories,
                        child: Row(
                          children: [
                            Text(
                              'View All',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: kTealColor,
                              size: 16.0.sp,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0.h),
                SizedBox(
                  height: 125.0.h,
                  child: _buildCategories(),
                ),
                // Divider(
                //   thickness: 0.5,
                //   color: Colors.grey.shade300,
                // ),
                // SizedBox(height: 10.0.h),
                Divider(
                  color: Colors.grey.shade300,
                  indent: 16.0.w,
                  endIndent: 16.0.w,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  child: Text(
                    'Recent',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                SizedBox(height: 10.0.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.5.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: vm.isProductsLoading
                            ? Center(
                                child: Lottie.asset(
                                  kAnimationLoading,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : ProductsList(
                                items: vm.otherUserProducts,
                                onProductTap: vm.onProductTap,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
    return SizedBox(
      height: 250.0.h,
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 3 / 2,
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
      ),
    );
  }
}
