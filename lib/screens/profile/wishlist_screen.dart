import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/products.dart';
import '../../providers/wishlist.dart';
import '../../state/mvvm_builder.widget.dart';
import '../../state/views/stateless.view.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/profile/wishlist_screen.vm.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/products_list.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = '/profile/wishlist';
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _WishListScreenView(),
      viewModel: WishlistScreenViewModel(),
    );
  }
}

class _WishListScreenView extends StatelessView<WishlistScreenViewModel> {
  @override
  Widget render(BuildContext context, WishlistScreenViewModel vm) {
    return Scaffold(
      appBar: const CustomAppBar(
        titleText: 'My Wishlist',
        backgroundColor: kTealColor,
        titleStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      body: Consumer2<UserWishlist, Products>(
        builder: (ctx, wishlist, products, __) {
          return RefreshIndicator(
            onRefresh: wishlist.fetchWishlist,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Builder(
                builder: (_) {
                  if (wishlist.isLoading || products.isLoading) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height -
                          kBottomNavigationBarHeight -
                          kToolbarHeight,
                      width: MediaQuery.of(context).size.width,
                      child: Lottie.asset(
                        kAnimationLoading,
                        fit: BoxFit.cover,
                        repeat: true,
                      ),
                    );
                  }

                  if (wishlist.items.isEmpty) {
                    if (wishlist.errorMessage != null) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height -
                            kBottomNavigationBarHeight -
                            kToolbarHeight,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(wishlist.errorMessage!),
                        ),
                      );
                    }
                    return SizedBox(
                      height: MediaQuery.of(context).size.height -
                          kBottomNavigationBarHeight -
                          kToolbarHeight,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                        child: Text('No products added to wishlist!'),
                      ),
                    );
                  }
                  final _products = <Product>[];

                  for (final id in wishlist.items) {
                    _products.add(products.findById(id)!);
                  }
                  return ProductsList(
                    items: _products,
                    onProductTap: vm.onProductTap,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// class WishlistScreen extends StatelessWidget {
//   const WishlistScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer2<UserWishlist, Products>(
//       builder: (ctx, wishlist, products, __) {
//         if (wishlist.isLoading || products.isLoading) {
//           return SizedBox.expand(
//             child: Lottie.asset(
//               kAnimationLoading,
//               fit: BoxFit.cover,
//               repeat: true,
//             ),
//           );
//         }

//         if (wishlist.items.isEmpty) {
//           return Center(
//             child: Text('No products added to wishlist!'),
//           );
//         }

//         return ProductsList(
//           items: products.items
//               .where((product) => wishlist.items.contains(product.id))
//               .toList(),
//           onProductTap: vm.onProductTap,
//         );
//       },
//     );
//   }
// }
