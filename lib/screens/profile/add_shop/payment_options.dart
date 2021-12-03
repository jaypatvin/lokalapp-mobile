import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
  const SetUpPaymentOptions({Key? key, required this.onSubmit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _SetupPaymentOptionsView(),
      viewModel: SetupPaymentOptionsViewModel(onSubmit: this.onSubmit),
    );
  }
}

class _SetupPaymentOptionsView extends HookView<SetupPaymentOptionsViewModel>
    with HookScreenLoader<SetupPaymentOptionsViewModel> {
  @override
  Widget screen(BuildContext context, SetupPaymentOptionsViewModel vm) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Add Shop',
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15.0),
            Text(
              'Set-up payment options',
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10.0),
            Consumer<ShopBody>(
              builder: (ctx, shopBody, _) {
                return ListTile(
                  tileColor:
                      shopBody.paymentOptions?.bankAccounts.isEmpty ?? true
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
                        .headline6!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  trailing: Icon(
                    shopBody.paymentOptions?.bankAccounts.isEmpty ?? true
                        ? Icons.add
                        : Icons.arrow_forward_ios,
                    color: kTealColor,
                    size: 18.0.r,
                  ),
                  onTap: vm.onAddBank,
                );
              },
            ),
            const SizedBox(height: 10),
            Consumer<ShopBody>(builder: (_, shopBody, __) {
              return ListTile(
                tileColor:
                    shopBody.paymentOptions?.gCashAccounts.isEmpty ?? true
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
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                title: Text(
                  'Wallet',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                trailing: Icon(
                  shopBody.paymentOptions?.gCashAccounts.isEmpty ?? true
                      ? Icons.add
                      : Icons.arrow_forward_ios,
                  color: kTealColor,
                  size: 18.0.r,
                ),
                onTap: vm.onAddWallet,
              );
            }),
            const Spacer(),
            Consumer<ShopBody>(builder: (_, shopBody, __) {
              final hasPayment =
                  (shopBody.paymentOptions?.bankAccounts.isNotEmpty ?? false) ||
                      (shopBody.paymentOptions?.gCashAccounts.isNotEmpty ??
                          false);
              return SizedBox(
                width: double.infinity,
                child: AppButton(
                  hasPayment ? 'Finish Set-up' : 'Skip',
                  kTealColor,
                  hasPayment,
                  () async => await performFuture(vm.onSubmit),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
