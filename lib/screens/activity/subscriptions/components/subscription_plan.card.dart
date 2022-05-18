import 'package:flutter/material.dart';

import '../../../../models/product_subscription_plan.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../widgets/app_button.dart';
import 'subscription_plan.details.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final void Function(ProductSubscriptionPlan)? onDetailsPressed;
  final void Function(ProductSubscriptionPlan)? onConfirmSubscription;
  final bool isBuyer;
  final ProductSubscriptionPlan subscriptionPlan;
  const SubscriptionPlanCard({
    Key? key,
    required this.subscriptionPlan,
    this.onDetailsPressed,
    this.onConfirmSubscription,
    this.isBuyer = true,
  }) : super(key: key);

  Widget _buildButtons() {
    if (isBuyer) {
      return SizedBox(
        width: double.infinity,
        child: AppButton.transparent(
          text: 'Details',
          onPressed: onDetailsPressed != null
              ? () => onDetailsPressed?.call(subscriptionPlan)
              : null,
        ),
      );
    }
    return Row(
      children: [
        Expanded(
          child: AppButton.transparent(
            text: 'Details',
            onPressed: onDetailsPressed != null
                ? () => onDetailsPressed?.call(subscriptionPlan)
                : null,
          ),
        ),
        if (subscriptionPlan.status == SubscriptionStatus.disabled)
          Expanded(
            child: AppButton.filled(
              text: 'Confirm',
              color: kOrangeColor,
              onPressed: onConfirmSubscription != null
                  ? () => onConfirmSubscription?.call(subscriptionPlan)
                  : null,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool _isActive;
    final BorderSide _side;
    switch (subscriptionPlan.status) {
      case SubscriptionStatus.cancelled:
        _side = const BorderSide(color: kPinkColor);
        _isActive = false;
        break;
      case SubscriptionStatus.unsubscribed:
        _side = BorderSide(color: Colors.grey.shade200);
        _isActive = false;
        break;
      default:
        _side = BorderSide.none;
        _isActive = true;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: _side,
      ),
      color: _isActive ? const Color(0xFFF1FAFF) : Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 16),
        child: Column(
          children: [
            SubscriptionPlanDetails(
              subscriptionPlan: subscriptionPlan,
              isBuyer: isBuyer,
            ),
            const SizedBox(height: 24),
            _buildButtons(),
          ],
        ),
      ),
    );
  }
}
