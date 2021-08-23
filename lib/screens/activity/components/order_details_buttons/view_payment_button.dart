import 'package:flutter/material.dart';

import '../../../../utils/themes.dart';
import '../../../../widgets/app_button.dart';
import 'order_actions.dart';

class ViewPaymentButton extends StatelessWidget {
  final void Function(OrderAction) onPress;
  const ViewPaymentButton({Key key, @required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: ADD VIEW PROOF OF PAYMENT FUNCTION
    return AppButton(
      "View Proof of Payment",
      kTealColor,
      false,
      () => this.onPress(OrderAction.viewPayment),
    );
  }
}
