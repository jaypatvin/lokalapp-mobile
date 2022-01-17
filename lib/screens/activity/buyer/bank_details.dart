import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/order.dart';
import '../../../providers/bank_codes.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/hook.view.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/activity/buyer/bank_details.vm.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/overlays/screen_loader.dart';
import '../../../widgets/photo_box.dart';
import 'processing_payment.dart';

class BankDetails extends StatelessWidget {
  const BankDetails({
    Key? key,
    required this.order,
    this.paymentMode = PaymentMode.gCash,
  }) : super(key: key);
  final Order order;
  final PaymentMode paymentMode;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _WalletDetailsView(),
      viewModel: BankDetailsViewModel(
        order: order,
        paymentMode: paymentMode,
      ),
    );
  }
}

class _WalletDetailsView extends HookView<BankDetailsViewModel>
    with HookScreenLoader<BankDetailsViewModel> {
  @override
  Widget screen(BuildContext context, BankDetailsViewModel vm) {
    final numberFormat = useMemoized<NumberFormat>(
      () => NumberFormat('#,###.0#', 'en_US'),
    );

    return Scaffold(
      appBar: CustomAppBar(
        titleText: '${vm.paymentMode == PaymentMode.gCash ? "Wallet" : "Bank"} '
            'Transfer/Deposit',
        titleStyle: const TextStyle(color: Colors.white),
        backgroundColor: kTealColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(24.0.h),
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(text: 'Please deposit '),
                  TextSpan(
                    text: 'P ${numberFormat.format(vm.price)}',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextSpan(
                    text:
                        ' to any of these ${vm.paymentMode == PaymentMode.gCash ? "wallet" : "bank"} accounts:',
                  ),
                ],
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0.h),
              child: ListView.builder(
                itemCount: vm.paymentAccounts.length,
                itemBuilder: (ctx, index) {
                  final _account = vm.paymentAccounts[index];

                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context
                              .read<BankCodes>()
                              .getById(_account.bankCode)
                              .name,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 5,
                              fit: FlexFit.tight,
                              child: Text(
                                'Account Number:',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              child: Text(
                                _account.accountNumber,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 5,
                              fit: FlexFit.tight,
                              child: Text(
                                'Account Name:',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              child: Text(
                                _account.accountName,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          if (vm.proofOfPayment != null)
            PhotoBox(
              shape: BoxShape.rectangle,
              file: vm.proofOfPayment,
              displayBorder: false,
            ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 4.0.h),
            child: AppButton.custom(
              text: "${vm.proofOfPayment != null ? 'Re-u' : 'U'}"
                  'pload proof of payment',
              onPressed: vm.onImagePick,
              isFilled: vm.proofOfPayment == null,
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 4.0.h),
            child: AppButton.filled(
              text: 'Submit',
              color: vm.proofOfPayment != null ? kTealColor : Colors.grey,
              onPressed: vm.proofOfPayment != null
                  ? () async => performFuture<void>(vm.onSubmit)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
