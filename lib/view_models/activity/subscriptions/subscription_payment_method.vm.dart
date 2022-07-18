import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../app/app_router.dart';
import '../../../models/failure_exception.dart';
import '../../../models/order.dart';
import '../../../models/post_requests/product_subscription_plan/product_subscription_plan.request.dart';
import '../../../providers/cart.dart';
import '../../../providers/products.dart';
import '../../../services/api/api.dart';
import '../../../services/api/subscription_plan_api.dart';
import '../../../state/view_model.dart';

class SubscriptionPaymentMethodViewModel extends ViewModel {
  SubscriptionPaymentMethodViewModel({
    required this.request,
    required this.reschedule,
  });

  final ProductSubscriptionPlanRequest request;
  final bool reschedule;

  final _appRouter = locator<AppRouter>();

  late final double totalPrice;
  final SubscriptionPlanAPI _apiService = locator<SubscriptionPlanAPI>();

  @override
  void init() {
    final _productId = request.productId;
    final _quantity = request.quantity;
    final _product = context.read<Products>().findById(_productId);
    totalPrice = _quantity * _product!.basePrice;
  }

  Future<void> onSubmitHandler(PaymentMethod paymentMode) async {
    try {
      final _request = request.copyWith(paymentMethod: paymentMode);

      // this will throw if there are any errors
      final subscriptionPlan = await _apiService.createSubscriptionPlan(
        request: _request,
      );

      final success = !reschedule ||
          await _apiService.autoRescheduleConflicts(
            planId: subscriptionPlan.id,
          );

      if (success) {
        context.read<ShoppingCart>().remove(request.productId);
        _appRouter.pushNamedAndRemoveUntil(
          AppRoute.discover,
          DiscoverRoutes.cartConfirmation,
          arguments: CartConfirmationArguments(
            isSubscription: true,
          ),
          predicate: ModalRoute.withName(DashboardRoutes.discover),
        );
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }
}
