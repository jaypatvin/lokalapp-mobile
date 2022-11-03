import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

import '../../../models/order.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/hook.view.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/activity/buyer/cash_on_delivery.vm.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/overlays/constrained_scrollview.dart';
import '../../../widgets/overlays/screen_loader.dart';

class CashOnDelivery extends StatelessWidget {
  const CashOnDelivery({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _CashOnDeliveryView(),
      viewModel: CashOnDeliveryViewModel(order),
    );
  }
}

class _CashOnDeliveryView extends HookView<CashOnDeliveryViewModel>
    with HookScreenLoader {
  @override
  Widget screen(BuildContext context, CashOnDeliveryViewModel vm) {
    final numberFormat = useMemoized<NumberFormat>(
      () => NumberFormat('#,###.0#', 'en_US'),
    );

    final price = useMemoized<String>(
      () => numberFormat.format(
        vm.order.products.fold<double>(
          0.0,
          (double prev, product) => prev + product.price,
        ),
      ),
    );

    final termsConditionHandler = useMemoized<TapGestureRecognizer>(
      () => TapGestureRecognizer()
        ..onTap = () {
          debugPrint('Terms & Conditions tapped');
        },
    );

    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Cash on Delivery',
        titleStyle: const TextStyle(color: Colors.white),
        backgroundColor: kTealColor,
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: ConstrainedScrollView(
        child: Column(
          children: [
            const SizedBox(height: 42),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 46),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(text: 'Please prepare '),
                    TextSpan(
                      text: 'P $price',
                      style: Theme.of(context).textTheme.subtitle2?.copyWith(
                            color: kOrangeColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const TextSpan(
                      text: ' for when the courier arrives.\n\n'
                          'By completing this order, you agree to all ',
                    ),
                    TextSpan(
                      text: 'Terms & Conditions',
                      recognizer: termsConditionHandler,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(color: kTealColor),
                    ),
                  ],
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.black),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: AppButton.filled(
                  text: 'Continue with Cash on Delivery',
                  onPressed: () => performFuture<void>(vm.onSubmitHandler),
                ),
              ),
            ),
            const SizedBox(height: 24.0)
          ],
        ),
      ),
    );
  }
}
