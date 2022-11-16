import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_navigator.dart';
import '../../models/shop.dart';
import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../routers/app_router.dart';
import '../../routers/discover/cart/checkout.props.dart';
import '../../routers/discover/product_detail.props.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../activity/subscriptions/subscription_schedule.dart';
import '../discover/product_detail.dart';
import 'checkout.dart';
import 'components/order_details.dart';

class ShopCheckout extends StatelessWidget {
  static const routeName = '/cart/checkout/shop';
  final Shop shop;
  const ShopCheckout({
    super.key,
    required this.shop,
  });
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
              return _OrdersCard(
                key: ValueKey<String>(key),
                productId: key,
              );
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
    super.key,
    required this.productId,
  });

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
                context.read<AppRouter>().navigateTo(
                      AppRoute.discover,
                      ProductDetail.routeName,
                      arguments: ProductDetailProps(product),
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
                          builder: (_) => SubscriptionSchedule.create(
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
                      context.read<AppRouter>().navigateTo(
                            AppRoute.discover,
                            Checkout.routeName,
                            arguments: CheckoutProps(productId),
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
