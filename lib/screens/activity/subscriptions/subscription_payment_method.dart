import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../providers/cart.dart';
import '../../../providers/products.dart';
import '../../../providers/subscriptions.dart';
import '../../../utils/constants/themes.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/overlays/screen_loader.dart';
import '../../../widgets/payment_options.widget.dart';
import '../../activity/buyer/processing_payment.dart';
import '../../cart/cart_confirmation.dart';

class SubscriptionPaymentMethod extends StatefulWidget {
  final SubscriptionPlanBody subscriptionPlanBody;
  final bool reschedule;

  const SubscriptionPaymentMethod({
    Key? key,
    required this.subscriptionPlanBody,
    required this.reschedule,
  }) : super(key: key);

  @override
  _SubscriptionPaymentMethodState createState() =>
      _SubscriptionPaymentMethodState();
}

class _SubscriptionPaymentMethodState extends State<SubscriptionPaymentMethod>
    with ScreenLoader {
  Future<void> _onSubmitHandler(
    BuildContext context,
    PaymentMode paymentMode,
  ) async {
    try {
      final subscriptionProvider = context.read<SubscriptionProvider>();
      widget.subscriptionPlanBody.paymentMethod = paymentMode.value;

      final subscriptionPlan = await subscriptionProvider
          .createSubscriptionPlan(widget.subscriptionPlanBody.toMap());

      if (subscriptionPlan != null && this.widget.reschedule) {
        await subscriptionProvider.autoReschedulePlan(subscriptionPlan.id);
      }

      if (subscriptionPlan != null) {
        context
            .read<ShoppingCart>()
            .remove(widget.subscriptionPlanBody.productId);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) {
              return CartConfirmation(
                isSubscription: true,
              );
            },
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget screen(BuildContext context) {
    final _productId = widget.subscriptionPlanBody.productId;
    final _quantity = widget.subscriptionPlanBody.quantity!;
    final _product = context.read<Products>().findById(_productId);
    final double _totalPrice = _quantity * _product!.basePrice;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        backgroundColor: Colors.transparent,
        titleText: "Choose a Payment Option",
        onPressedLeading: () => Navigator.pop(context),
        leadingColor: kTealColor,
        titleStyle: TextStyle(color: Colors.black),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 180.0.h,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SvgPicture.asset(
                      "assets/houses_background.svg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "P$_totalPrice",
                          style:
                              Theme.of(context).textTheme.headline3!.copyWith(
                                    color: kOrangeColor,
                                  ),
                        ),
                        Text(
                          "Total Payment",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0.h),
            PaymentOptionsWidget(
              onPaymentPressed: (mode) async => performFuture<void>(
                () async => await _onSubmitHandler(context, mode),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
