import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/bank_code.dart';
import '../../../providers/bank_codes.dart';
import '../../../providers/post_requests/shop_body.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/stateless.view.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/profile/shop/add_shop/add_bank.vm.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';

class AddBank extends StatelessWidget {
  const AddBank({Key? key, this.type = BankType.bank}) : super(key: key);
  final BankType type;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _AddBankView(),
      viewModel: AddBankViewModel(
        context.read<BankCodes>(),
        type,
      ),
    );
  }
}

class _AddBankView extends StatelessView<AddBankViewModel> {
  @override
  Widget render(BuildContext context, AddBankViewModel vm) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Add Shop',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vm.header,
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 10.h),
            Consumer<ShopBody>(
              builder: (ctx, shopBody, _) {
                final items = vm.items(shopBody.paymentOptions);
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length + 1,
                  itemBuilder: (_, index) {
                    if (items.length == index) {
                      return Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        width: double.infinity,
                        height: 100.h,
                        child: AppButton(
                          vm.addButtonLabel,
                          kTealColor,
                          false,
                          vm.onAddBankDetails,
                        ),
                      );
                    }

                    final item = items[index];
                    return Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: InkWell(
                        onTap: () => vm.onEditBankDetails(item),
                        child: Row(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              width: MediaQuery.of(context).size.width / 6,
                              height: 100.h,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  context
                                      .read<BankCodes>()
                                      .getById(item.bank)
                                      .iconUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) =>
                                      Text('No image'),
                                ),
                              ),
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${vm.getBankName(item.bank)}\n',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: '${item.accountName}\n'
                                          '${item.accountNumber}',
                                    ),
                                  ],
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      ?.copyWith(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 16.0),
                              child: Icon(
                                MdiIcons.squareEditOutline,
                                color: kTealColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: Consumer<ShopBody>(builder: (_, shopBody, __) {
                final isBankEmpty =
                    shopBody.paymentOptions?.bankAccounts.isEmpty ?? true;

                return AppButton(
                  isBankEmpty ? 'Next' : 'Back to Payment Options',
                  kTealColor,
                  true,
                  isBankEmpty ? vm.onAddBankDetails : vm.onBackToPaymentOptions,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
