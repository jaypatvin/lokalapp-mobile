import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/app_router.dart';
import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/app_button.dart';
import 'components/order_details.dart';

class CheckoutCart extends StatelessWidget {
  const CheckoutCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _CheckOutCartAppBar(),
      body: Consumer<ShoppingCart>(
        builder: (_, cart, __) {
          if (cart.orders.isEmpty) {
            return Stack(
              children: [
                Positioned.fill(
                  top: 10,
                  child: SvgPicture.asset(
                    kSvgBackgroundHouses,
                    color: kTealColor,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 62),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Your shopping cart is empty. '
                                'Start looking for products in our',
                          ),
                          TextSpan(
                            text: '\nDiscover Page',
                            style: TextStyle(
                              color: kTealColor,
                            ),
                          ),
                          TextSpan(text: '!'),
                        ],
                        style: TextStyle(
                          fontFamily: 'Goldplay',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF4F4F4F),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            itemCount: cart.orders.length,
            padding: const EdgeInsets.only(top: 30),
            itemBuilder: (ctx, index) {
              // get shopId from Map
              final key = cart.orders.keys.elementAt(index);
              final shop = context.read<Shops>().findById(key)!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 3,
                    ),
                    child: Text(
                      shop.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ListView.separated(
                              // this shrinkWrap is okay since this widget
                              // lives inside a Card which will be handled
                              // by another listView above this (which will
                              // handle the re/builds)
                              shrinkWrap: true,
                              itemCount: cart.orders[key]!.length,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
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
                                    locator<AppRouter>().navigateTo(
                                      AppRoute.discover,
                                      DiscoverRoutes.productDetail,
                                      arguments: ProductDetailArguments(
                                        product: product,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 12.0),
                            AppButton.transparent(
                              text: 'Checkout',
                              width: double.infinity,
                              onPressed: () {
                                locator<AppRouter>().navigateTo(
                                  AppRoute.discover,
                                  DiscoverRoutes.shopCheckout,
                                  arguments: ShopCheckoutArguments(shop: shop),
                                );
                              },
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
  const _CheckOutCartAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kOrangeColor,
      elevation: 0,
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
          const SizedBox(width: 18 + 8.0), // this is needed to center the text
          Text(
            'Shopping Cart',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: kYellowColor),
          ),
          const SizedBox(width: 8.0),
          Consumer<ShoppingCart>(
            builder: (_, cart, __) {
              final quantity = cart.orders.values
                  .map<int>((orders) => orders.length)
                  .fold<int>(0, (a, b) => a + b);

              if (quantity <= 0) {
                return const SizedBox();
              }

              return Container(
                padding: const EdgeInsets.all(1.0),
                decoration: const BoxDecoration(
                  color: kYellowColor,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Center(
                  child: Text(
                    quantity.toString(), //cart.orders.length.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(color: Colors.white, fontSize: 12),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
