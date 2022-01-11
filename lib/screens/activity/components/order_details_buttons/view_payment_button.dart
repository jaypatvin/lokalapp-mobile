import 'package:flutter/material.dart';

import '../../../../utils/constants/themes.dart';
import '../../../../widgets/app_button.dart';
import 'order_actions.dart';

class ViewPaymentButton extends StatelessWidget {
  final void Function(OrderAction) onPress;
  const ViewPaymentButton({Key? key, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      'View Proof of Payment',
      kTealColor,
      false,
      () => onPress(OrderAction.viewPayment),
    );
  }
}
