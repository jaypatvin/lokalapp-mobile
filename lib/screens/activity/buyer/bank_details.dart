import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
import '../../../widgets/overlays/constrained_scrollview.dart';
import '../../../widgets/overlays/screen_loader.dart';
import '../../../widgets/photo_box.dart';

class BankDetails extends StatelessWidget {
  const BankDetails({
    super.key,
    required this.order,
    this.paymentMethod = PaymentMethod.eWallet,
  });
  final Order order;
  final PaymentMethod paymentMethod;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _WalletDetailsView(),
      viewModel: BankDetailsViewModel(
        order: order,
        paymentMode: paymentMethod,
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
        titleText:
            '${vm.paymentMode == PaymentMethod.eWallet ? "Wallet" : "Bank"} '
            'Transfer/Deposit',
        titleStyle: const TextStyle(color: Colors.white),
        backgroundColor: kTealColor,
      ),
      body: ConstrainedScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 46),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(text: 'Please deposit '),
                    TextSpan(
                      text: 'P ${numberFormat.format(vm.price)}',
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextSpan(
                      text: ' to any of these '
                          '${vm.paymentMode == PaymentMethod.eWallet ? "wallet" : "bank"} accounts:',
                    ),
                  ],
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
            ...vm.paymentAccounts.map<Widget>((account) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 46),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.read<BankCodes>().getById(account.bankCode).name,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          fit: FlexFit.tight,
                          child: Text(
                            'Account Number:',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: Text(
                            account.accountNumber,
                            style: Theme.of(context).textTheme.subtitle2,
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
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: Text(
                            account.accountName,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                      ],
                    ),
                    if (vm.paymentAccounts.indexOf(account) !=
                        vm.paymentAccounts.length - 1)
                      const SizedBox(height: 32)
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 16.0),
            const Spacer(),
            if (vm.proofOfPayment != null)
              PhotoBox(
                imageSource: PhotoBoxImageSource(file: vm.proofOfPayment),
                shape: BoxShape.rectangle,
                displayBorder: false,
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppButton.custom(
                text: "${vm.proofOfPayment != null ? 'Re-u' : 'U'}"
                    'pload proof of payment',
                onPressed: vm.onImagePick,
                isFilled: vm.proofOfPayment == null,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppButton.filled(
                text: 'Submit',
                color: vm.proofOfPayment != null ? kTealColor : Colors.grey,
                width: double.infinity,
                onPressed: vm.proofOfPayment != null
                    ? () async => performFuture<void>(vm.onSubmit)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
