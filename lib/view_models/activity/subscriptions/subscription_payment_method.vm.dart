import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../models/app_navigator.dart';
import '../../../models/failure_exception.dart';
import '../../../models/order.dart';
import '../../../providers/cart.dart';
import '../../../providers/products.dart';
import '../../../providers/subscriptions.dart';
import '../../../routers/app_router.dart';
import '../../../screens/cart/cart_confirmation.dart';
import '../../../services/api/api.dart';
import '../../../services/api/subscription_plan_api_service.dart';
import '../../../state/view_model.dart';

class SubscriptionPaymentMethodViewModel extends ViewModel {
  SubscriptionPaymentMethodViewModel({
    required this.subscriptionPlanBody,
    required this.reschedule,
  });

  final SubscriptionPlanBody subscriptionPlanBody;
  final bool reschedule;

  late final double totalPrice;
  late final SubscriptionPlanAPIService _apiService;

  @override
  void init() {
    _apiService = SubscriptionPlanAPIService(context.read<API>());

    final _productId = subscriptionPlanBody.productId;
    final _quantity = subscriptionPlanBody.quantity!;
    final _product = context.read<Products>().findById(_productId);
    totalPrice = _quantity * _product!.basePrice;
  }

  Future<void> onSubmitHandler(PaymentMethod paymentMode) async {
    try {
      subscriptionPlanBody.paymentMethod = paymentMode.value;

      // this will throw if there are any errors
      final subscriptionPlan = await _apiService.createSubscriptionPlan(
        body: subscriptionPlanBody.toMap(),
      );

      final success = !reschedule ||
          await _apiService.autoRescheduleConflicts(
            planId: subscriptionPlan.id!,
          );

      if (success) {
        context.read<ShoppingCart>().remove(subscriptionPlanBody.productId);
        // the user is making a new subscription, meaning that the app
        // is currently at the Discover Tab
        AppRouter.discoverNavigatorKey.currentState?.push(
          AppNavigator.appPageRoute(
            builder: (_) => const CartConfirmation(
              isSubscription: true,
            ),
          ),
        );
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }
}
