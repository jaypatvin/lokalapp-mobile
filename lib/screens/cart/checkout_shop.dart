import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/app_router.dart';
import '../../models/app_navigator.dart';
import '../../models/shop.dart';
import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../activity/subscriptions/subscription_schedule_create.dart';
import 'components/order_details.dart';

class ShopCheckout extends StatelessWidget {
  final Shop shop;
  const ShopCheckout({
    Key? key,
    required this.shop,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: shop.name,
        titleStyle: const TextStyle(color: kYellowColor),
        backgroundColor: kOrangeColor,
      ),
      body: Consumer<ShoppingCart>(
        builder: (_, cart, __) {
          if (cart.orders[shop.id] == null) return const SizedBox();

          final orders = cart.orders[shop.id]!;
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
            itemCount: orders.length,
            separatorBuilder: (ctx, index) => const SizedBox(height: 20),
            itemBuilder: (ctx, index) {
              final key = orders.keys.elementAt(index);
              if (key == null) return const SizedBox();
              return _OrdersCard(productId: key);
            },
          );
        },
      ),
    );
  }
}

class _OrdersCard extends StatelessWidget {
  final String productId;
  const _OrdersCard({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = context.read<Products>().findById(productId);
    final order = context.read<ShoppingCart>().getProductOrder(productId)!;
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(21),
        child: Column(
          children: [
            OrderDetails(
              product: product!,
              quantity: order.quantity,
              onEditTap: () {
                locator<AppRouter>().navigateTo(
                  AppRoute.discover,
                  DiscoverRoutes.productDetail,
                  arguments: ProductDetailArguments(product: product),
                );
              },
            ),
            const Divider(),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: RichText(
                text: TextSpan(
                  text: 'Order Total\t',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                  children: [
                    TextSpan(
                      text: (product.basePrice * order.quantity).toString(),
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            color: kOrangeColor,
                            fontWeight: FontWeight.w600,
                          ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (context.read<Products>().findById(productId)!.canSubscribe)
                  Expanded(
                    child: AppButton.transparent(
                      text: 'Subscribe',
                      onPressed: () => Navigator.push(
                        context,
                        AppNavigator.appPageRoute(
                          builder: (_) => SubscriptionScheduleCreate(
                            productId: productId,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (context.read<Products>().findById(productId)!.canSubscribe)
                  const SizedBox(width: 8.0),
                Expanded(
                  child: AppButton.filled(
                    text: 'Checkout',
                    onPressed: () {
                      locator<AppRouter>().navigateTo(
                        AppRoute.discover,
                        DiscoverRoutes.checkout,
                        arguments: CheckoutArguments(productId: productId),
                      );
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
