import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../models/order.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/stateless.view.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/activity/buyer/payment_option.vm.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/payment_options.widget.dart';

class PaymentOptionScreen extends StatelessWidget {
  const PaymentOptionScreen({super.key, required this.order});
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 175,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SvgPicture.asset(
                      kSvgBackgroundHouses,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'P ${vm.totalPayment}',
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              ?.copyWith(fontSize: 44, color: kOrangeColor),
                        ),
                        Text(
                          'Total payment',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PaymentOptionsWidget(
              onPaymentPressed: vm.onPaymentPressed,
              bankEnabled: vm.bankEnabled,
              walletEnabled: vm.walletEnabled,
            ),
          ],
        ),
      ),
    );
  }
}
