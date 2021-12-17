import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../models/order.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/hook.view.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/activity/buyer/cash_on_delivery.vm.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
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
    final _numberFormat = useMemoized<NumberFormat>(
      () => NumberFormat('#,###.0#', 'en_US'),
    );

    final _price = useMemoized<String>(
      () => _numberFormat.format(
        vm.order.products.fold<double>(
          0.0,
          (double prev, product) => prev + product.price!,
        ),
      ),
    );

    final _termsConditionHandler = useMemoized<TapGestureRecognizer>(
      () => TapGestureRecognizer()
        ..onTap = () {
          print('Terms & Conditions tapped');
        },
    );

    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Cash on Delivery',
        titleStyle: TextStyle(color: Colors.white),
        backgroundColor: kTealColor,
        leadingColor: Colors.white,
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          SizedBox(height: 24.0.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 36.0.w),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'Please prepare '),
                  TextSpan(
                    text: 'P $_price',
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: kOrangeColor, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' for when the courier arrives.')
                ],
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 36.0.w),
            child: RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'By completing this order, you agree to all '),
                    TextSpan(
                      text: 'Terms & Conditions',
                      recognizer: _termsConditionHandler,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          color: kTealColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.black)),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0.w),
            child: Container(
              width: double.infinity,
              child: AppButton(
                'Continue with Cash on Delivery',
                kTealColor,
                true,
                () async => await performFuture<void>(vm.onSubmitHandler),
              ),
            ),
          ),
          SizedBox(height: 24.0.h)
        ],
      ),
    );
  }
}
