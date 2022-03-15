import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../models/lokal_category.dart';
import '../../providers/products.dart';
import '../../routers/app_router.dart';
import '../../routers/discover/product_detail.props.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/products_list.dart';
import '../cart/cart_container.dart';
import 'product_detail.dart';

class CategoriesLanding extends StatelessWidget {
  const CategoriesLanding({
    Key? key,
    required this.category,
  }) : super(key: key);

  final LokalCategory category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: category.name,
        backgroundColor: kOrangeColor,
      ),
      body: CartContainer(
        alwaysDisplayButton: true,
        child: Consumer<Products>(
          builder: (ctx, products, _) {
            final _items = products.items
                .where((product) => product.productCategory == category.id)
                .toList();
            if (products.isLoading) {
              return SizedBox.expand(
                child: Lottie.asset(
                  kAnimationLoading,
                  fit: BoxFit.cover,
                  repeat: true,
                ),
              );
            } else if (products.items.isEmpty || _items.isEmpty) {
              return SizedBox.expand(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'There are currently no products for the '
                      '${category.name} category.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }

            return ProductsList(
              items: _items,
              onProductTap: (String id) {
                final _product = products.items.firstWhere((p) => p.id == id);
                AppRouter.discoverNavigatorKey.currentState?.pushNamed(
                  ProductDetail.routeName,
                  arguments: ProductDetailProps(_product),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
