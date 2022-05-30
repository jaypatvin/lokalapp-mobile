import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../models/order.dart';
import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../routers/app_router.dart';
import '../../routers/discover/cart/checkout_schedule.props.dart';
import '../../routers/discover/product_detail.props.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/overlays/constrained_scrollview.dart';
import '../discover/product_detail.dart';
import 'checkout_schedule.dart';
import 'components/order_details.dart';

class Checkout extends HookWidget {
  static const routeName = '/cart/checkout/shop/checkout';
  final String productId;
  const Checkout({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = context.watch<Products>().findById(productId);
    final shop = context.watch<Shops>().findById(product!.shopId)!;

    final _onCustomerPickUpToggle =
        useMemoized<void Function(DeliveryOption?)?>(
      () {
        if (shop.deliveryOptions.pickup) {
          return (value) => context.read<ShoppingCart>().updateOrder(
                productId: productId,
                deliveryOption: value,
              );
        }
        return null;
      },
      [shop, productId],
    );

    final _onDeliveryToggle = useMemoized<void Function(DeliveryOption?)?>(() {
      if (shop.deliveryOptions.delivery) {
        return (value) => context.read<ShoppingCart>().updateOrder(
              productId: productId,
              deliveryOption: value,
            );
      }
      return null;
    });

    useEffect(
      () {
        if (!shop.deliveryOptions.pickup) {
          context.read<ShoppingCart>().updateOrder(
                productId: productId,
                deliveryOption: DeliveryOption.delivery,
                notify: false,
              );
        }
        return;
      },
      [shop, product],
    );
    return Scaffold(
      appBar: const CustomAppBar(
        titleText: 'Checkout',
        backgroundColor: kOrangeColor,
        titleStyle: TextStyle(color: kYellowColor),
      ),
      body: ConstrainedScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 30,
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    'Delivery Option',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.black),
                  ),
                  const SizedBox(width: 9),
                  Text(
                    'Pick 1',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontWeight: FontWeight.w400),
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
                      onChanged: _onCustomerPickUpToggle,
                      selected: DeliveryOption.pickup == order.deliveryOption,
                      title: Text(
                        'Customer Pick-up',
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                      ),
                    ),
                    RadioListTile<DeliveryOption>(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      value: DeliveryOption.delivery,
                      groupValue: order.deliveryOption,
                      onChanged: _onDeliveryToggle,
                      selected: DeliveryOption.delivery == order.deliveryOption,
                      title: Text(
                        'Delivery',
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const Spacer(),
            const Divider(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 21),
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
      ),
    );
  }
}
