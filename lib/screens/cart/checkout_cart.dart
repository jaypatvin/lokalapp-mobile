import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16.0.w,
                      right: 16.0.w,
                      top: 16.0.h,
                    ),
                    child: Text(
                      shop.name!,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(fontSize: 18.0.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.0.w,
                      vertical: 8.0.h,
                    ),
                    child: Card(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(16.0.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.0.w, 16.0.h, 16.0.w, 0),
                        child: Column(
                          children: [
                            ListView.builder(
                              // this shrinkWrap is okay since this widget
                              // lives inside a Card which will be handled
                              // by another listView above this (which will
                              // handle the re/builds)
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
                                return Padding(
                                  padding: orderIndex != 0
                                      ? EdgeInsets.only(top: 8.0.h)
                                      : EdgeInsets.zero,
                                  child: OrderDetails(
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
                                  ),
                                );
                              },
                            ),
                            // const SizedBox(height: 12.0),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0.h),
                              child: SizedBox(
                                width: double.infinity,
                                child: AppButton.transparent(
                                  text: 'Checkout',
                                  onPressed: () {
                                    context.read<AppRouter>().navigateTo(
                                          AppRoute.discover,
                                          ShopCheckout.routeName,
                                          arguments: ShopCheckoutProps(shop),
                                        );
                                  },
                                ),
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
          SizedBox(width: 25.0.r + 8.0.w), // this is needed to center the text
          const Text('Shopping Cart'),
          SizedBox(width: 8.0.w),
          Container(
            padding: const EdgeInsets.all(1.0),
            decoration: const BoxDecoration(
              color: kOrangeColor,
              shape: BoxShape.circle,
            ),
            constraints: BoxConstraints(
              minWidth: 25.0.r,
              minHeight: 25.0.r,
            ),
            child: Consumer<ShoppingCart>(
              builder: (_, cart, __) {
                final quantity = cart.orders.values
                    .map<int>((orders) => orders.length)
                    .fold<int>(0, (a, b) => a + b);
                return Center(
                  child: Text(
                    quantity.toString(), //cart.orders.length.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(color: Colors.white),
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
