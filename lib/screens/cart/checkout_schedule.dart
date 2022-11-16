import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../models/post_requests/orders/order_create.request.dart';
import '../../providers/auth.dart';
import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../routers/app_router.dart';
import '../../routers/discover/product_detail.props.dart';
import '../../services/api/api.dart';
import '../../services/api/order_api_service.dart';
import '../../utils/constants/themes.dart';
import '../../utils/functions.utils.dart';
import '../../utils/repeated_days_generator/schedule_generator.dart';
import '../../widgets/app_button.dart';
import '../../widgets/calendar_picker/calendar_picker.dart';
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
  const CheckoutSchedule({super.key, required this.productId});

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

  Future<void> _placeOrderHandler(String shopId) async {
    try {
      final auth = context.read<Auth>();
      final user = auth.user!;
      final order =
          context.read<ShoppingCart>().orders[shopId]![widget.productId]!;
      final cart = context.read<ShoppingCart>();
      await _apiService.create(
        request: OrderCreateRequest(
          products: [
            OrderCreateProduct(
              id: widget.productId,
              quantity: order.quantity,
            ),
          ],
          buyerId: user.id,
          shopId: shopId,
          deliveryOption: order.deliveryOption,
          deliveryDate: order.schedule!,
          instruction: order.notes,
        ),
      );

      AppRouter.discoverNavigatorKey.currentState
          ?.pushNamedAndRemoveUntil(
            CartConfirmation.routeName,
            ModalRoute.withName(
              Discover.routeName,
            ),
          )
          .then((_) => cart.remove(widget.productId));
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
        backgroundColor: kYellowColor,
        titleStyle: TextStyle(color: kOrangeColor),
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Delivery Schedule',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Colors.black),
                ),
              ),
            ),
            _DeliverySchedule(
              key: UniqueKey(),
              shopId: shop.id,
              productId: widget.productId,
            ),
            const SizedBox(height: 20.0),
            const Spacer(),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 21,
              ),
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
    super.key,
    required this.shopId,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<Shops>().findById(shopId)!;
    final operatingHours = shop.operatingHours;
    final selectableDates = useMemoized(
      () => ScheduleGenerator().getSelectableDates(operatingHours),
      [operatingHours],
    );

    useEffect(
      () {
        final now = DateTime.now();

        final order = context.read<ShoppingCart>().getProductOrder(productId);

        if (order?.schedule?.year == now.year &&
            order?.schedule?.month == now.month &&
            order?.schedule?.day == now.day) {
          final timeOfDayNow = TimeOfDay.fromDateTime(now);
          final closing = stringToTimeOfDay(operatingHours.endTime);
          if ((timeOfDayNow.hour * 60 + timeOfDayNow.minute) >
              (closing.hour * 60 + closing.minute)) {
            final nearestAvailableDate = selectableDates.reduce((a, b) {
              if (a.difference(now).isNegative) {
                return b;
              }
              return a;
            });
            context.read<ShoppingCart>().updateOrder(
                  productId: productId,
                  schedule: nearestAvailableDate,
                  notify: false,
                );
          }
        }
        return;
      },
      [operatingHours, selectableDates],
    );

    return Consumer<ShoppingCart>(
      builder: (_, cart, __) {
        final delivery = cart.orders[shopId]![productId]!.schedule;
        return CalendarPicker(
          closing: stringToTimeOfDay(operatingHours.endTime),
          selectableDates: selectableDates,
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
