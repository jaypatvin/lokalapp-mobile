import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../providers/cart.dart';
import '../../../providers/products.dart';
import '../../../providers/subscriptions.dart';
import '../../../routers/app_router.dart';
import '../../../screens/activity/buyer/processing_payment.dart';
import '../../../screens/cart/cart_confirmation.dart';
import '../../../state/view_model.dart';

class SubscriptionPaymentMethodViewModel extends ViewModel {
  SubscriptionPaymentMethodViewModel({
    required this.subscriptionPlanBody,
    required this.reschedule,
  });

  final SubscriptionPlanBody subscriptionPlanBody;
  final bool reschedule;

  late final double totalPrice;

  @override
  void init() {
    final _productId = subscriptionPlanBody.productId;
    final _quantity = subscriptionPlanBody.quantity!;
    final _product = context.read<Products>().findById(_productId);
    this.totalPrice = _quantity * _product!.basePrice;
  }

  Future<void> onSubmitHandler(PaymentMode paymentMode) async {
    try {
      final subscriptionProvider = context.read<SubscriptionProvider>();
      subscriptionPlanBody.paymentMethod = paymentMode.value;

      final subscriptionPlan = await subscriptionProvider
          .createSubscriptionPlan(subscriptionPlanBody.toMap());

      if (subscriptionPlan != null && reschedule) {
        await subscriptionProvider.autoReschedulePlan(subscriptionPlan.id);
      }

      if (subscriptionPlan != null) {
        context.read<ShoppingCart>().remove(subscriptionPlanBody.productId);
        AppRouter.pushNewScreen(
          context,
          screen: CartConfirmation(
            isSubscription: true,
          ),
        );
      }
    } catch (e) {
      showToast(e.toString());
    }
  }
}
