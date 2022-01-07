import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../routers/app_router.dart';
import '../../routers/discover/cart/checkout_shop.props.dart';
import '../../routers/discover/product_detail.props.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/app_button.dart';
import '../discover/product_detail.dart';
import 'checkout_shop.dart';
import 'components/order_details.dart';

class CheckoutCart extends StatelessWidget {
  static const routeName = '/cart/checkout';
  const CheckoutCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _CheckOutCartAppBar(),
      body: Consumer<ShoppingCart>(
        builder: (_, cart, __) {
          return ListView.builder(
            itemCount: cart.orders.length,
            itemBuilder: (ctx, index) {
              // get shopId from Map
              final key = cart.orders.keys.elementAt(index);
              final shop = context.read<Shops>().findById(key)!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 24.0),
                  Text(
                    shop.name!,
                    style: const TextStyle(
                      color: kNavyColor,
                      fontFamily: 'Goldplay',
                      fontWeight: FontWeight.w800,
                      fontSize: 24.0,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Card(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: cart.orders[key]!.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, orderIndex) {
                                // get the shopOrders
                                final orders = cart.orders[key]!;
                                // get productId from Map using orderIndex
                                final _key = orders.keys.elementAt(orderIndex);
                                final product =
                                    context.read<Products>().findById(_key);
                                return OrderDetails(
                                  product: product!,
                                  quantity: orders[_key]!.quantity,
                                  onEditTap: () {
                                    context.read<AppRouter>().navigateTo(
                                          AppRoute.discover,
                                          ProductDetail.routeName,
                                          arguments: ProductDetailProps(
                                            product,
                                          ),
                                        );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 12.0),
                            SizedBox(
                              width: double.infinity,
                              child: AppButton(
                                'Checkout',
                                kTealColor,
                                false,
                                () {
                                  context.read<AppRouter>().navigateTo(
                                        AppRoute.discover,
                                        ShopCheckout.routeName,
                                        arguments: ShopCheckoutProps(shop),
                                      );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _CheckOutCartAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final double height;

  const _CheckOutCartAppBar({this.height = kToolbarHeight});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kTealColor,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_sharp,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Shopping Cart',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Goldplay',
              fontWeight: FontWeight.w600,
              fontSize: 24.0,
            ),
          ),
          const SizedBox(width: 8.0),
          Container(
            padding: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              color: kOrangeColor,
              borderRadius: BorderRadius.circular(25.0),
            ),
            constraints: const BoxConstraints(
              minWidth: 18.0,
              minHeight: 18.0,
            ),
            child: Consumer<ShoppingCart>(
              builder: (_, cart, __) {
                final quantity = cart.orders.values
                    .map<int>((orders) => orders.length)
                    .fold<int>(0, (a, b) => a + b);
                return Center(
                  child: Text(
                    quantity.toString(), //cart.orders.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Goldplay',
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
