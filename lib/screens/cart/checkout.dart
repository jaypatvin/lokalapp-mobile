import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../routers/app_router.dart';
import '../../routers/discover/cart/checkout_schedule.props.dart';
import '../../routers/discover/product_detail.props.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../discover/product_detail.dart';
import 'checkout_schedule.dart';
import 'components/order_details.dart';

class Checkout extends StatelessWidget {
  static const routeName = '/cart/checkout/shop/checkout';
  final String productId;
  const Checkout({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = context.read<Products>().findById(productId);
    final shop = context.read<Shops>().findById(product!.shopId)!;
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Checkout',
        backgroundColor: kTealColor,
        titleStyle: const TextStyle(color: Colors.white),
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
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
            margin: const EdgeInsets.all(16.0),
            child: Consumer<ShoppingCart>(
              builder: (_, cart, __) {
                final order = cart.orders[shop.id]![productId]!;
                return Card(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: OrderDetails(
                      product: product,
                      quantity: order.quantity,
                      onEditTap: () {
                        context.read<AppRouter>().navigateTo(
                              AppRoute.discover,
                              ProductDetail.routeName,
                              arguments: ProductDetailProps(product),
                            );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  'Delivery Option',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontSize: 18.0.sp),
                ),
                SizedBox(width: 10.0.w),
                Text(
                  'Pick 1',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
          Consumer<ShoppingCart>(
            builder: (_, cart, __) {
              final order = cart.orders[shop.id]![productId]!;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<DeliveryOption>(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    value: DeliveryOption.pickup,
                    groupValue: order.deliveryOption,
                    onChanged: (value) => cart.updateOrder(
                      productId: productId,
                      deliveryOption: value,
                    ),
                    selected: DeliveryOption.pickup == order.deliveryOption,
                    title: const Text('Customer Pick-up'),
                  ),
                  RadioListTile<DeliveryOption>(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    value: DeliveryOption.delivery,
                    groupValue: order.deliveryOption,
                    onChanged: (value) => cart.updateOrder(
                      productId: productId,
                      deliveryOption: value,
                    ),
                    selected: DeliveryOption.delivery == order.deliveryOption,
                    title: const Text('Delivery'),
                  ),
                ],
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: AppButton.transparent(
                    text: 'Cancel',
                    color: kPinkColor,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: AppButton.filled(
                    text: 'Continue',
                    onPressed: () {
                      context.read<AppRouter>().navigateTo(
                            AppRoute.discover,
                            CheckoutSchedule.routeName,
                            arguments: CheckoutScheduleProps(productId),
                          );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
