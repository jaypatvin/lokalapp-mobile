import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:oktoast/oktoast.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/app_router.dart';
import '../../models/lokal_images.dart';
import '../../models/order.dart';
import '../../screens/activity/components/order_details_buttons/order_actions.dart';
import '../../services/api/api.dart';
import '../../services/api/order_api.dart';
import '../../state/view_model.dart';
import '../../utils/functions.utils.dart';

class OrderDetailsViewModel extends ViewModel {
  OrderDetailsViewModel({
    required this.order,
    required this.isBuyer,
  });
  final Order order;
  final bool isBuyer;

  final OrderAPI _apiService = locator<OrderAPI>();
  final _appRouter = locator<AppRouter>();

  Future<void> onPress(OrderAction action) async {
    try {
      switch (action) {
        case OrderAction.cancel:
          await _apiService.cancel(orderId: order.id);
          _appRouter.popScreen(AppRoute.activity);
          break;
        case OrderAction.decline:
          await _apiService.decline(orderId: order.id);
          _appRouter.popScreen(AppRoute.activity);
          break;
        case OrderAction.confirm:
          final success = await _apiService.confirm(orderId: order.id);
          if (success) {
            _appRouter.navigateTo(
              AppRoute.activity,
              ActivityRoutes.orderConfirmed,
              arguments: OrderConfirmedArguments(
                order: order,
                isBuyer: isBuyer,
              ),
            );
          }
          break;
        case OrderAction.pay:
          _appRouter.navigateTo(
            AppRoute.activity,
            ActivityRoutes.paymentOptionScreen,
            arguments: PaymentOptionScreenArguments(order: order),
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
          final success = await _apiService.confirmPayment(orderId: order.id);

          if (success) {
            _appRouter.navigateTo(
              AppRoute.activity,
              ActivityRoutes.paymentConfirmed,
              arguments: PaymentConfirmedArguments(order: order),
            );
          }
          break;
        case OrderAction.shipOut:
          final success = await _apiService.shipOut(orderId: order.id);

          if (success) {
            _appRouter.navigateTo(
              AppRoute.activity,
              ActivityRoutes.shippedOut,
              arguments: ShippedOutArguments(order: order),
            );
          }
          break;
        case OrderAction.received:
          final success = await _apiService.receive(orderId: order.id);

          if (success) {
            _appRouter.navigateTo(
              AppRoute.activity,
              ActivityRoutes.orderReceived,
              arguments: OrderReceivedArguments(order: order),
            );
          }

          break;
        case OrderAction.orderAgain:
          //TODO: add logic for order again
          break;
        case OrderAction.addReview:
          _appRouter.navigateTo(
            AppRoute.activity,
            ActivityRoutes.reviewOrder,
            arguments: ReviewOrderArguments(
              order: order,
            ),
          );
          break;
        case OrderAction.viewReview:
          _appRouter.navigateTo(
            AppRoute.activity,
            ActivityRoutes.viewReviews,
            arguments: ViewReviewsArguments(
              order: order,
            ),
          );
          break;
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast('There was an error performing the task. Please try again.');
    }
  }
}
