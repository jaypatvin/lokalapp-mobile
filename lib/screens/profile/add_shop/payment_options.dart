import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../models/bank_code.dart';
import '../../../providers/post_requests/shop_body.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/hook.view.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/profile/shop/add_shop/payment_options.vm.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/overlays/screen_loader.dart';

class SetUpPaymentOptions extends StatelessWidget {
  static const routeName = '/profile/shop/paymentOptions';
  final void Function() onSubmit;
  final bool edit;

  factory SetUpPaymentOptions.edit({
    Key? key,
    required void Function() onSubmit,
  }) {
    return SetUpPaymentOptions._(
      onSubmit,
      true,
      key: key,
    );
  }

  factory SetUpPaymentOptions.create({
    Key? key,
    required void Function() onSubmit,
  }) {
    return SetUpPaymentOptions._(
      onSubmit,
      false,
      key: key,
    );
  }

  const SetUpPaymentOptions._(this.onSubmit, this.edit, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _SetupPaymentOptionsView(),
      viewModel: SetupPaymentOptionsViewModel(onSubmit: onSubmit, edit: edit),
    );
  }
}

class _SetupPaymentOptionsView extends HookView<SetupPaymentOptionsViewModel>
    with HookScreenLoader<SetupPaymentOptionsViewModel> {
  @override
  Widget screen(BuildContext context, SetupPaymentOptionsViewModel vm) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: vm.edit ? 'Edit Shop' : 'Add Shop',
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              'Set-up payment options',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 12.0),
            Consumer<ShopBody>(
              builder: (ctx, shopBody, _) {
                final isBankAccountsEmpty = shopBody.paymentOptions
                    .where((bank) => bank.type == BankType.bank)
                    .isEmpty;

                return ListTile(
                  tileColor: isBankAccountsEmpty
                      ? Colors.grey[300]
                      : kInviteScreenColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: SvgPicture.asset(
                      kSvgBankPayment,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    'Bank Transfer/Deposit',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(color: Colors.black),
                  ),
                  trailing: Icon(
                    isBankAccountsEmpty ? Icons.add : Icons.arrow_forward_ios,
                    color: kTealColor,
                  ),
                  onTap: vm.onAddBank,
                );
              },
            ),
            const SizedBox(height: 12),
            Consumer<ShopBody>(
              builder: (_, shopBody, __) {
                final isWalletAccountsEmpty = shopBody.paymentOptions
                    .where((bank) => bank.type == BankType.wallet)
                    .isEmpty;
                return ListTile(
                  tileColor: isWalletAccountsEmpty
                      ? Colors.grey[300]
                      : kInviteScreenColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        kSvgGCashPayment,
                      ),
                    ),
                  ),
                  title: Text(
                    'Wallet',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(color: Colors.black),
                  ),
                  trailing: Icon(
                    isWalletAccountsEmpty ? Icons.add : Icons.arrow_forward_ios,
                    color: kTealColor,
                  ),
                  onTap: vm.onAddWallet,
                );
              },
            ),
            const Spacer(),
            Consumer<ShopBody>(
              builder: (_, shopBody, __) {
                final hasPayment = shopBody.paymentOptions.isNotEmpty;
                return SizedBox(
                  width: double.infinity,
                  child: AppButton.custom(
                    text: hasPayment ? 'Finish Set-up' : 'Skip',
                    isFilled: hasPayment,
                    onPressed: () async => performFuture(vm.onSubmit),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
