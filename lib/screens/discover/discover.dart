import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/auth.dart';
import '../../providers/categories.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../utils/shared_preference.dart';
import '../../view_models/discover/discover.vm.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/inputs/search_text_field.dart';
import '../../widgets/overlays/onboarding.dart';
import '../../widgets/products_list.dart';
import '../cart/cart_container.dart';
import '../profile/components/product_card.dart';

class Discover extends StatefulWidget {
  static const routeName = '/discover';
  const Discover({Key? key}) : super(key: key);

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  late final DiscoverViewModel _viewModel;
  late final StreamSubscription<String> _errorSubscription;

  @override
  void initState() {
    super.initState();
    _viewModel = DiscoverViewModel(context)..init();
    _errorSubscription = _viewModel.errorStream.listen(_errorListener);
  }

  @override
  void dispose() {
    _errorSubscription.cancel();
    _viewModel.dispose();
    super.dispose();
  }

  void _errorListener(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }

  Widget _buildCategories() {
    return Consumer<Categories>(
      builder: (ctx, provider, _) {
        if (provider.isLoading) {
          return CircularProgressIndicator();
        }
        final categories = provider.categories;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: categories.length,
          itemBuilder: (ctx, index) {
            return SizedBox(
              width: 100.0.w,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35.0.r,
                    backgroundColor: Color(0XFFF1FAFF),
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
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0.sp,
                    ),
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
  Widget build(BuildContext context) {
    return Onboarding(
      screen: MainScreen.discover,
      child: Scaffold(
        appBar: CustomAppBar(
          titleText: "Discover",
          backgroundColor: kOrangeColor,
          buildLeading: false,
        ),
        body: CartContainer(
          displayButton: true,
          child: ChangeNotifierProvider<DiscoverViewModel>.value(
            value: _viewModel,
            builder: (ctx, _) {
              return Consumer<DiscoverViewModel>(
                builder: (ctx2, vm, _) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.0.h),
                        GestureDetector(
                          child: Hero(
                            tag: "search_field",
                            child: SearchTextField(
                              enabled: false,
                            ),
                          ),
                          onTap: vm.onSearch,
                        ),
                        SizedBox(height: 10.0.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                          child: Text(
                            "Recommended",
                            style: Theme.of(context).textTheme.headline6,
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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                          child: Row(
                            children: [
                              Text(
                                "Explore Categories",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: vm.onExploreCategories,
                                child: Row(
                                  children: [
                                    Text(
                                      "View All",
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_outlined,
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
                        SizedBox(height: 10.0.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                          child: Text(
                            "Recent",
                            style: Theme.of(context).textTheme.headline6,
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
                  );
                },
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
    return Container(
      height: 250.0.h,
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 3 / 2,
          crossAxisCount: 1,
        ),
        itemBuilder: (ctx, index) {
          final shop = ctx.read<Shops>().findById(products[index].shopId)!;
          final gallery = products[index].gallery;
          final isGalleryEmpty = gallery == null || gallery.isEmpty;
          final productImage = !isGalleryEmpty
              ? gallery!.firstWhere((g) => g.url.isNotEmpty)
              : null;
          return Container(
            padding: index == 0
                ? EdgeInsets.only(left: 16.0.w, right: 2.5.w)
                : index == products.length - 1
                    ? EdgeInsets.only(left: 2.5.w, right: 16.0.w)
                    : EdgeInsets.symmetric(horizontal: 2.5.w),
            child: GestureDetector(
              onTap: () => this.onProductTap(products[index].id),
              child: ProductCard(
                productId: products[index].id,
                name: products[index].name,
                imageUrl: isGalleryEmpty ? '' : productImage!.url,
                price: products[index].basePrice,
                shopName: shop.name,
                shopImageUrl: shop.profilePhoto,
              ),
            ),
          );
        },
      ),
    );
  }
}
