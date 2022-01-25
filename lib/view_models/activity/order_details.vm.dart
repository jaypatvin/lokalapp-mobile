import 'package:provider/provider.dart';

import '../../models/lokal_images.dart';
import '../../models/order.dart';
import '../../routers/app_router.dart';
import '../../screens/activity/buyer/order_received.dart';
import '../../screens/activity/buyer/payment_option.dart';
import '../../screens/activity/components/order_details_buttons/order_actions.dart';
import '../../screens/activity/seller/order_confirmed.dart';
import '../../screens/activity/seller/payment_confirmed.dart';
import '../../screens/activity/seller/shipped_out.dart';
import '../../services/api/api.dart';
import '../../services/api/order_api_service.dart';
import '../../state/view_model.dart';
import '../../utils/functions.utils.dart';

class OrderDetailsViewModel extends ViewModel {
  OrderDetailsViewModel({
    required this.order,
    required this.isBuyer,
  });
  final Order order;
  final bool isBuyer;

  late final OrderAPIService _apiService;

  @override
  void init() {
    _apiService = OrderAPIService(context.read<API>());
  }

  Future<void> onPress(OrderAction action) async {
    switch (action) {
      case OrderAction.cancel:
        await _apiService.cancel(orderId: order.id!);
        break;
      case OrderAction.decline:
        await _apiService.decline(orderId: order.id!);
        break;
      case OrderAction.confirm:
        final success = await _apiService.confirm(orderId: order.id!);
        if (success) {
          AppRouter.pushNewScreen(
            context,
            screen: OrderConfirmed(
              order: order,
              isBuyer: isBuyer,
            ),
          );
        }
        break;
      case OrderAction.pay:
        AppRouter.pushNewScreen(
          context,
          screen: PaymentOptionScreen(order: order),
        );
        break;
      case OrderAction.viewPayment:
        final galleryItems = order.proofOfPayment != null
            ? <LokalImages>[
                LokalImages(url: order.proofOfPayment!, order: 0),
              ]
            : <LokalImages>[];
        openGallery(context, 0, galleryItems);
        break;
      case OrderAction.confirmPayment:
        final success = await _apiService.confirmPayment(orderId: order.id!);

        if (success) {
          AppRouter.pushNewScreen(
            context,
            screen: PaymentConfirmed(order: order),
          );
        }
        break;
      case OrderAction.shipOut:
        final success = await _apiService.shipOut(orderId: order.id!);

        if (success) {
          AppRouter.pushNewScreen(context, screen: ShippedOut(order: order));
        }
        break;
      case OrderAction.received:
        final success = await _apiService.receive(orderId: order.id!);

        if (success) {
          AppRouter.pushNewScreen(
            context,
            screen: OrderReceived(order: order),
          );
        }

        break;
      case OrderAction.orderAgain:
        //TODO: add logic for order again
        break;
    }
  }
}
