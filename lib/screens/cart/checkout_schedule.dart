import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../providers/user.dart';
import '../../services/lokal_api_service.dart';
import '../../utils/calendar_picker/calendar_picker.dart';
import '../../utils/repeated_days_generator/schedule_generator.dart';
import '../../utils/themes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../discover/product_detail.dart';
import 'components/order_details.dart';
import 'order_placed.dart';

class CheckoutSchedule extends StatelessWidget {
  final String productId;
  const CheckoutSchedule({Key key, @required this.productId}) : super(key: key);

  void _placeOrderHandler(BuildContext context, String shopId) async {
    final user = context.read<CurrentUser>();
    final order = context.read<ShoppingCart>().orders[shopId][productId];

    // TODO: separate payload body into another class
    final response = await LokalApiService.instance.orders.create(
      idToken: user.idToken,
      data: {
        "products": [
          {
            "id": productId,
            "quantity": order.quantity,
          }
        ],
        "buyer_id": user.id,
        "shop_id": shopId,
        "delivery_option": order.deliveryOption.value,
        "delivery_date": order.schedule.toIso8601String(),
        "instruction": order.notes,
      },
    );

    if (response.statusCode == 200) {
      context.read<ShoppingCart>().remove(productId);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OrderPlaced(),
        ),
      );
    } else {
      // TODO: show snackbar?
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = context.read<Products>().findById(productId);
    final shop = context.read<Shops>().findById(product.shopId);
    return Scaffold(
      appBar: CustomAppBar(
        titleText: "Checkout",
        backgroundColor: kTealColor,
        titleStyle: TextStyle(color: Colors.white),
        leadingColor: Colors.white,
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 24.0),
            Text(
              shop.name,
              style: TextStyle(
                color: kNavyColor,
                fontFamily: "Goldplay",
                fontWeight: FontWeight.w800,
                fontSize: 24.0,
              ),
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              child: Consumer<ShoppingCart>(
                builder: (_, cart, __) {
                  final order = cart.orders[shop.id][productId];
                  return Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey[300]),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: OrderDetails(
                        product: product,
                        quantity: order.quantity,
                        onEditTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => ProductDetail(product)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Delivery Schedule",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontFamily: "Goldplay",
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            _DeliverySchedule(
              shopId: shop.id,
              productId: productId,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      "Cancel",
                      kPinkColor,
                      false,
                      () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Consumer<ShoppingCart>(
                      builder: (ctx, cart, child) {
                        final order = cart.orders[shop.id][product.id];
                        return AppButton(
                          "Place Order",
                          kTealColor,
                          true,
                          order.schedule != null
                              ? () => _placeOrderHandler(context, shop.id)
                              : null,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}

class _DeliverySchedule extends StatelessWidget {
  final String shopId;
  final String productId;
  const _DeliverySchedule({
    Key key,
    @required this.shopId,
    @required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shop = context.read<Shops>().findById(shopId);
    final operatingHours = shop.operatingHours;
    final selectableDates =
        ScheduleGenerator().getSelectableDates(operatingHours);

    // copied from product_schedule (hey, it's repeated code -.-)
    return Consumer<ShoppingCart>(builder: (_, cart, __) {
      final delivery = cart.orders[shopId][productId].schedule;
      return CalendarCarousel(
        onDayPressed: (date) {
          final now = DateTime.now().subtract(Duration(days: 1));
          if (date.isBefore(now)) return;
          cart.updateOrder(productId: productId, schedule: date);
        },
        selectedDateTime: delivery,
        markedDatesMap: [delivery],
        height: MediaQuery.of(context).size.height * 0.55,
        width: MediaQuery.of(context).size.width * 0.9,
        selectableDates: selectableDates,
      );
    });
  }
}
