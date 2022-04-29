import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:oktoast/oktoast.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../app/app_router.dart';
import '../../../models/failure_exception.dart';
import '../../../models/order.dart';
import '../../../models/post_requests/orders/order_pay.request.dart';
import '../../../services/api/api.dart';
import '../../../services/api/order_api.dart';
import '../../../state/view_model.dart';

class CashOnDeliveryViewModel extends ViewModel {
  CashOnDeliveryViewModel(this.order);
  final Order order;
  final _appRouter = locator<AppRouter>();
  final OrderAPI _apiService = locator<OrderAPI>();

  Future<void> onSubmitHandler() async {
    try {
      final _success = await _apiService.pay(
        orderId: order.id,
        request: OrderPayRequest(paymentMethod: PaymentMethod.cod),
      );

      if (_success) {
        _appRouter.navigateTo(
          AppRoute.activity,
          ActivityRoutes.processingPayment,
          arguments: ProcessingPaymentArguments(
            order: order,
            paymentMode: PaymentMethod.cod,
          ),
        );
      } else {
        throw FailureException('Error performing task. Please try again.');
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }
}
