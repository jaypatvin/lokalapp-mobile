import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../models/order.dart';
import '../../providers/auth.dart';
import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../routers/app_router.dart';
import '../../routers/discover/product_detail.props.dart';
import '../../services/api/api.dart';
import '../../services/api/order_api_service.dart';
import '../../utils/calendar_picker/calendar_picker.dart';
import '../../utils/constants/themes.dart';
import '../../utils/repeated_days_generator/schedule_generator.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/overlays/constrained_scrollview.dart';
import '../../widgets/overlays/screen_loader.dart';
import '../discover/discover.dart';
import '../discover/product_detail.dart';
import 'cart_confirmation.dart';
import 'components/order_details.dart';

class CheckoutSchedule extends StatefulWidget {
  static const routeName = '/cart/checkout/shop/checkout/schedule';
  final String productId;
  const CheckoutSchedule({Key? key, required this.productId}) : super(key: key);

  @override
  _CheckoutScheduleState createState() => _CheckoutScheduleState();
}

class _CheckoutScheduleState extends State<CheckoutSchedule> with ScreenLoader {
  late final OrderAPIService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = OrderAPIService(context.read<API>());
  }

  Future<void> _placeOrderHandler(
    String? shopId,
  ) async {
    try {
      final auth = context.read<Auth>();
      final user = auth.user!;
      final order =
          context.read<ShoppingCart>().orders[shopId]![widget.productId]!;
      final _cart = context.read<ShoppingCart>();
      await _apiService.create(
        body: {
          'products': [
            {
              'id': widget.productId,
              'quantity': order.quantity,
            }
          ],
          'buyer_id': user.id,
          'shop_id': shopId,
          'delivery_option': order.deliveryOption.value,
          'delivery_date': order.schedule!.toIso8601String(),
          'instruction': order.notes,
        },
      );

      AppRouter.discoverNavigatorKey.currentState
          ?.pushNamedAndRemoveUntil(
            CartConfirmation.routeName,
            ModalRoute.withName(
              Discover.routeName,
            ),
          )
          .then((_) => _cart.remove(widget.productId));
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast('Failed to place order!');
    }
  }

  @override
  Widget screen(BuildContext context) {
    final product = context.read<Products>().findById(widget.productId);
    final shop = context.read<Shops>().findById(product!.shopId)!;
    return Scaffold(
      appBar: const CustomAppBar(
        titleText: 'Checkout',
        backgroundColor: kTealColor,
        titleStyle: TextStyle(color: Colors.white),
      ),
      body: ConstrainedScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 16.0.w,
                right: 16.0.w,
                top: 16.0.h,
              ),
              child: Text(
                shop.name,
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
                  final order = cart.orders[shop.id]![widget.productId]!;
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
            const SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Delivery Schedule',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontSize: 18.0.sp),
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: _DeliverySchedule(
                shopId: shop.id,
                productId: widget.productId,
              ),
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton.transparent(
                        text: 'Cancel',
                        color: kPinkColor,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Consumer<ShoppingCart>(
                        builder: (ctx, cart, child) {
                          final order = cart.orders[shop.id]![product.id]!;
                          return AppButton.filled(
                            text: 'Place Order',
                            onPressed: order.schedule != null
                                ? () async {
                                    await performFuture<void>(
                                      () async => _placeOrderHandler(
                                        shop.id,
                                      ),
                                    );
                                  }
                                : null,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}

class _DeliverySchedule extends HookWidget {
  final String? shopId;
  final String? productId;
  const _DeliverySchedule({
    Key? key,
    required this.shopId,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<Shops>().findById(shopId)!;
    final operatingHours = shop.operatingHours;
    // final selectableDates =
    //     ScheduleGenerator().getSelectableDates(operatingHours);
    final selectableDates = useMemoized(
      () => ScheduleGenerator().getSelectableDates(operatingHours),
      [operatingHours],
    );

    // copied from product_schedule (hey, it's repeated code -.-)
    return Consumer<ShoppingCart>(
      builder: (_, cart, __) {
        final delivery = cart.orders[shopId]![productId]!.schedule;
        return CalendarPicker(
          selectableDates: selectableDates,
          selectedDate: delivery ?? DateTime.now(),
          onDayPressed: (date) {
            final now = DateTime.now().subtract(const Duration(days: 1));
            if (date.isBefore(now)) return;
            cart.updateOrder(productId: productId, schedule: date);
          },
          markedDates: [delivery ?? DateTime.now()],
        );
      },
    );
  }
}
