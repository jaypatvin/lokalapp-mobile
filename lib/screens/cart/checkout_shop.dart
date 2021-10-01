import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_shop.dart';
import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../utils/themes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../discover/product_detail.dart';
import '../subscriptions/subscription_schedule.dart';
import 'checkout.dart';
import 'components/order_details.dart';

class ShopCheckout extends StatelessWidget {
  final ShopModel shop;
  const ShopCheckout({
    Key key,
    @required this.shop,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: this.shop.name,
        titleStyle: TextStyle(color: Colors.white),
        buildLeading: true,
        backgroundColor: kTealColor,
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: Consumer<ShoppingCart>(
        builder: (_, cart, __) {
          final orders = cart.orders[shop.id];
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (ctx, index) {
              final key = orders.keys.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: _OrdersCard(productId: key),
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
    Key key,
    @required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = context.read<Products>().findById(productId);
    final order = context.read<ShoppingCart>().getProductOrder(productId);
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey[300]),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            OrderDetails(
              product: product,
              quantity: order.quantity,
              onEditTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ProductDetail(product)),
              ),
            ),
            Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: RichText(
                text: TextSpan(
                  text: "Order Total\t",
                  style: TextStyle(color: Color(0xFF828282)),
                  children: [
                    TextSpan(
                      text: (product.basePrice * order.quantity).toString(),
                      style: TextStyle(color: Colors.orange),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              // TODO: ADD ON PRESS FUNCTIONS
              children: [
                Expanded(
                  child: AppButton(
                    "Subscribe",
                    kTealColor,
                    false,
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SubscriptionSchedule(
                          productId: productId,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: AppButton(
                    "Checkout",
                    kTealColor,
                    true,
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Checkout(productId: productId),
                      ),
                    ),
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
