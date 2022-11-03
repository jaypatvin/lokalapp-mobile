import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../models/app_navigator.dart';
import '../../../models/failure_exception.dart';
import '../../../models/order.dart';
import '../../../models/post_requests/orders/order_pay.request.dart';
import '../../../routers/app_router.dart';
import '../../../screens/activity/buyer/processing_payment.dart';
import '../../../services/api/api.dart';
import '../../../services/api/order_api_service.dart';
import '../../../state/view_model.dart';

class CashOnDeliveryViewModel extends ViewModel {
  CashOnDeliveryViewModel(this.order);
  final Order order;

  late final OrderAPIService _apiService;

  @override
  void init() {
    _apiService = OrderAPIService(context.read<API>());
  }

  Future<void> onSubmitHandler() async {
    try {
      final success = await _apiService.pay(
        orderId: order.id,
        request: OrderPayRequest(paymentMethod: PaymentMethod.cod),
      );

      if (success) {
        AppRouter.activityNavigatorKey.currentState?.push(
          AppNavigator.appPageRoute(
            builder: (_) => ProcessingPayment(
              order: order,
              paymentMode: PaymentMethod.cod,
            ),
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
