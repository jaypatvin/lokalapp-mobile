import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../models/order.dart';
import '../../../routers/app_router.dart';
import '../../../screens/activity/buyer/order_received.dart';
import '../../../screens/activity/buyer/payment_option.dart';
import '../../../screens/activity/order_details.dart';
import '../../../screens/activity/seller/order_confirmed.dart';
import '../../../screens/activity/seller/payment_confirmed.dart';
import '../../../screens/activity/seller/shipped_out.dart';
import '../../../services/api/api.dart';
import '../../../services/api/order_api_service.dart';
import '../../../state/view_model.dart';

class GroupedOrdersViewModel extends ViewModel {
  GroupedOrdersViewModel({required this.isBuyer});
  final bool isBuyer;

  late final OrderAPIService _apiService;

  @override
  void init() {
    _apiService = OrderAPIService(context.read<API>());
  }

  Future<void> onSecondButtonPress(Order order) async {
    try {
      if (this.isBuyer) {
        switch (order.statusCode) {
          case 200:
            // AppRouter.pushNewScreen(
            //   context,
            //   screen: PaymentOption(order: order),
            // );
            AppRouter.activityNavigatorKey.currentState?.push(
              CupertinoPageRoute(
                builder: (_) => PaymentOption(order: order),
              ),
            );
            break;
          case 500:
            final success = await _apiService.receive(orderId: order.id!);
            if (success) {
              AppRouter.pushNewScreen(
                context,
                screen: OrderReceived(order: order),
              );
            }

            break;
          default:
            break;
        }
      } else {
        switch (order.statusCode) {
          case 100:
            final success = await _apiService.confirm(orderId: order.id!);
            if (success) {
              AppRouter.pushNewScreen(
                context,
                screen: OrderConfirmed(
                  order: order,
                  isBuyer: this.isBuyer,
                ),
              );
            }
            break;
          case 300:
            if (order.paymentMethod == "cod") {
              final success =
                  await _apiService.confirmPayment(orderId: order.id!);
              if (success) {
                AppRouter.pushNewScreen(
                  context,
                  screen: PaymentConfirmed(order: order),
                );
              }
            } else {
              AppRouter.pushNewScreen(
                context,
                screen: OrderDetails(
                  order: order,
                  isBuyer: this.isBuyer,
                ),
              );
            }
            break;
          case 400:
            final success = await _apiService.shipOut(orderId: order.id!);
            if (success) {
              AppRouter.pushNewScreen(
                context,
                screen: ShippedOut(order: order),
              );
            }
            break;
          default:
            // do nothing
            break;
        }
      }
    } catch (_) {
      showToast('Error performing task. Please try again.');
    }
  }
}
