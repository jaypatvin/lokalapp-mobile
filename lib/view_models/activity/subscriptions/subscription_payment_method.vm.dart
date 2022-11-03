import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../models/app_navigator.dart';
import '../../../models/failure_exception.dart';
import '../../../models/order.dart';
import '../../../models/post_requests/product_subscription_plan/product_subscription_plan.request.dart';
import '../../../providers/cart.dart';
import '../../../providers/products.dart';
import '../../../routers/app_router.dart';
import '../../../screens/cart/cart_confirmation.dart';
import '../../../screens/discover/discover.dart';
import '../../../services/api/api.dart';
import '../../../services/api/subscription_plan_api_service.dart';
import '../../../state/view_model.dart';

class SubscriptionPaymentMethodViewModel extends ViewModel {
  SubscriptionPaymentMethodViewModel({
    required this.request,
    required this.reschedule,
  });

  final ProductSubscriptionPlanRequest request;
  final bool reschedule;

  late final double totalPrice;
  late final SubscriptionPlanAPIService _apiService;

  @override
  void init() {
    _apiService = SubscriptionPlanAPIService(context.read<API>());

    final productId = request.productId;
    final quantity = request.quantity;
    final product = context.read<Products>().findById(productId);
    totalPrice = quantity * product!.basePrice;
  }

  Future<void> onSubmitHandler(PaymentMethod paymentMode) async {
    try {
      final requestCopy = request.copyWith(paymentMethod: paymentMode);

      // this will throw if there are any errors
      final subscriptionPlan = await _apiService.createSubscriptionPlan(
        request: requestCopy,
      );

      final success = !reschedule ||
          await _apiService.autoRescheduleConflicts(
            planId: subscriptionPlan.id,
          );

      if (success) {
        context.read<ShoppingCart>().remove(request.productId);
        // the user is making a new subscription, meaning that the app
        // is currently at the Discover Tab
        AppRouter.discoverNavigatorKey.currentState?.pushAndRemoveUntil(
          AppNavigator.appPageRoute(
            builder: (_) => const CartConfirmation(
              isSubscription: true,
            ),
          ),
          ModalRoute.withName(Discover.routeName),
        );
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }
}
