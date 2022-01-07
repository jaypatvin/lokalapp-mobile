import 'package:flutter/material.dart';

import '../../../models/order.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/stateless.view.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/activity/buyer/payment_option.vm.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/payment_options.widget.dart';

class PaymentOption extends StatelessWidget {
  const PaymentOption({Key? key, required this.order}) : super(key: key);
  final Order order;
  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _PaymentOptionView(),
      viewModel: PaymentOptionViewModel(order),
    );
  }
}

class _PaymentOptionView extends StatelessView<PaymentOptionViewModel> {
  @override
  Widget render(BuildContext context, PaymentOptionViewModel vm) {
    debugPrint(vm.bankEnabled.toString());
    return Scaffold(
      appBar: const CustomAppBar(
        titleText: 'Choose a Payment Option',
        titleStyle: TextStyle(color: Colors.black),
        backgroundColor: Colors.white,
        leadingColor: kTealColor,
      ),
      body: PaymentOptionsWidget(
        onPaymentPressed: vm.onPaymentPressed,
        bankEnabled: vm.bankEnabled,
        walletEnabled: vm.walletEnabled,
      ),
    );
  }
}
