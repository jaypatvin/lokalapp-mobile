import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    Key? key,
    required this.shop,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: shop.name,
        titleStyle: const TextStyle(color: Colors.white),
        backgroundColor: kTealColor,
      ),
      body: Consumer<ShoppingCart>(
        builder: (_, cart, __) {
          if (cart.orders[shop.id] == null) return const SizedBox();

          final orders = cart.orders[shop.id]!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (ctx, index) {
              final key = orders.keys.elementAt(index);
              if (key == null) return const SizedBox();
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0.w,
                  vertical: 8.0.h,
                ),
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
        borderRadius: BorderRadius.circular(16.0.r),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0.w, 16.0.h, 16.0.w, 8.0.h),
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
            SizedBox(height: 8.0.h),
            Align(
              alignment: Alignment.centerRight,
              child: RichText(
                text: TextSpan(
                  text: 'Order Total\t',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w500,
                      ),
                  children: [
                    TextSpan(
                      text: (product.basePrice * order.quantity).toString(),
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontSize: 12.0.sp,
                            color: kOrangeColor,
                            fontWeight: FontWeight.w600,
                          ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.h),
              child: Row(
                children: [
                  if (context
                      .read<Products>()
                      .findById(productId)!
                      .canSubscribe)
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
                  if (context
                      .read<Products>()
                      .findById(productId)!
                      .canSubscribe)
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
            ),
          ],
        ),
      ),
    );
  }
}
