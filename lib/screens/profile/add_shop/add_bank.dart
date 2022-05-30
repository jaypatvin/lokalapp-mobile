import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

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
  const AddBank({
    Key? key,
    this.type = BankType.bank,
    this.edit = false,
  }) : super(key: key);
  final BankType type;
  final bool edit;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _AddBankView(),
      viewModel: AddBankViewModel(
        context.read<BankCodes>(),
        type,
        edit: edit,
      ),
    );
  }
}

class _AddBankView extends StatelessView<AddBankViewModel> {
  @override
  Widget render(BuildContext context, AddBankViewModel vm) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: vm.edit ? 'Edit Shop' : 'Add Shop',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              vm.header,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Consumer<ShopBody>(
                builder: (ctx, shopBody, _) {
                  final items = vm.items(shopBody.paymentOptions);
                  return ListView.builder(
                    itemCount: items.length + 1,
                    itemBuilder: (_, index) {
                      if (items.length == index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 8.0),
                          height: 86,
                          child: ElevatedButton(
                            onPressed: vm.onAddBankDetails,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent,
                              ),
                              elevation: MaterialStateProperty.all<double>(0),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: const BorderSide(color: kTealColor),
                                ),
                              ),
                            ),
                            child: Text(
                              vm.addButtonLabel,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Goldplay',
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kTealColor,
                              ),
                            ),
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
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                width: 60,
                                height: 86,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: context
                                        .read<BankCodes>()
                                        .getById(item.bankCode)
                                        .iconUrl,
                                    fit: BoxFit.contain,
                                    placeholder: (_, __) => Shimmer(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (ctx, url, err) {
                                      if (context
                                          .read<BankCodes>()
                                          .getById(item.bankCode)
                                          .iconUrl
                                          .isEmpty) {
                                        return const Center(
                                          child: Text('No image.'),
                                        );
                                      }
                                      return const Center(
                                        child: Text('Error displaying image.'),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            '${vm.getBankName(item.bankCode)}\n',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
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
                                child: const Icon(
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
            ),
            SizedBox(
              width: double.infinity,
              child: Consumer<ShopBody>(
                builder: (_, shopBody, __) {
                  final isBankEmpty = shopBody.paymentOptions
                      .where((bank) => bank.type == vm.bankType)
                      .isEmpty;

                  return AppButton.filled(
                    text: isBankEmpty ? 'Next' : 'Back to Payment Options',
                    onPressed: isBankEmpty
                        ? vm.onAddBankDetails
                        : vm.onBackToPaymentOptions,
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
