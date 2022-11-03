import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/bank_code.dart';
import '../../../models/payment_option.dart';
import '../../../providers/bank_codes.dart';
import '../../../providers/post_requests/shop_body.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/hook.view.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/profile/shop/add_shop/add_bank_details.vm.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/inputs/input_field.dart';

class AddBankDetails extends StatelessWidget {
  const AddBankDetails({
    Key? key,
    required this.bankType,
    this.bankAccount,
    this.edit = false,
  }) : super(key: key);
  final PaymentOption? bankAccount;
  final BankType bankType;
  final bool edit;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _AddBankDetailsView(),
      viewModel: AddBankDetailsViewModel(
        bankType,
        context.read<ShopBody>(),
        context.read<BankCodes>(),
        GlobalKey<FormState>(),
        initialAccount: bankAccount,
        edit: edit,
      ),
    );
  }
}

class _AddBankDetailsView extends HookView<AddBankDetailsViewModel> {
  @override
  Widget render(BuildContext context, AddBankDetailsViewModel vm) {
    final chosenCode = useState<BankCode?>(vm.bank);

    final nameFocusNode = useFocusNode();
    final numberFocusNode = useFocusNode();

    useEffect(
      () {
        void bankListener() => vm.onBankChanged(chosenCode.value);
        chosenCode.addListener(bankListener);

        return () {
          chosenCode.removeListener(bankListener);
        };
      },
      [chosenCode],
    );

    final androidDropDown = useMemoized<Widget>(
      () {
        final List<DropdownMenuItem<BankCode>> dropDownItems = [];

        for (final code in vm.codes) {
          dropDownItems.add(
            DropdownMenuItem(
              value: code,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 21),
                child: Text(
                  code.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      ?.copyWith(color: Colors.black),
                ),
              ),
            ),
          );
        }

        return DropdownButtonHideUnderline(
          child: DropdownButton<BankCode>(
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: Text(
                'Select a Bank',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w400),
              ),
            ),
            value: chosenCode.value,
            isExpanded: true,
            items: dropDownItems,
            focusColor: Colors.white,
            icon: const Padding(
              padding: EdgeInsets.only(right: 21),
              child: Icon(
                MdiIcons.chevronDown,
                color: kTealColor,
              ),
            ),
            onChanged: (value) => chosenCode.value = value,
          ),
        );
      },
      [chosenCode.value],
    );

    final iOSPicker = useMemoized<Widget>(
      () {
        final pickerItems = vm.codes
            .map<Widget>(
              (code) => Center(
                child: Text(
                  code.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList();

        return CupertinoButton(
          child: Row(
            children: [
              if (chosenCode.value == null)
                Expanded(
                  child: Text(
                    'Select a Bank',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (chosenCode.value != null)
                Expanded(
                  child: Text(
                    chosenCode.value!.name,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              const Icon(
                MdiIcons.chevronDown,
                color: kTealColor,
              ),
            ],
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (ctx) {
                return SizedBox(
                  height: 200,
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                        textStyle: Theme.of(context).textTheme.bodyText2,
                        actionTextStyle: Theme.of(context).textTheme.bodyText2,
                        pickerTextStyle: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(color: Colors.black),
                      ),
                    ),
                    child: CupertinoPicker(
                      itemExtent: 32.0,
                      onSelectedItemChanged: (index) =>
                          chosenCode.value = vm.codes[index],
                      children: pickerItems,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      [chosenCode.value],
    );

    final kbActionsConfig = useMemoized<KeyboardActionsConfig>(
      () => KeyboardActionsConfig(
        keyboardBarColor: Colors.grey.shade200,
        actions: [
          KeyboardActionsItem(
            focusNode: nameFocusNode,
            toolbarButtons: [
              (node) {
                return TextButton(
                  onPressed: () => node.unfocus(),
                  child: Text(
                    'Done',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                );
              },
            ],
          ),
          KeyboardActionsItem(
            focusNode: numberFocusNode,
            toolbarButtons: [
              (node) {
                return TextButton(
                  onPressed: () => node.unfocus(),
                  child: Text(
                    'Done',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                );
              },
            ],
          ),
        ],
      ),
      [],
    );

    return Scaffold(
      appBar: CustomAppBar(
        titleText: vm.edit ? 'Edit Shop' : 'Add Shop',
        actions: vm.initialAccount != null
            ? [
                IconButton(
                  onPressed: vm.onDeleteAccount,
                  icon: const Icon(MdiIcons.trashCanOutline),
                ),
              ]
            : null,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: KeyboardActions(
              config: kbActionsConfig,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: vm.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        'Bank Transfer/Deposit Options',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Bank',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        decoration: const ShapeDecoration(
                          color: Color(0xFFF2F2F2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                          ),
                        ),
                        child: Platform.isIOS ? iOSPicker : androidDropDown,
                      ),
                      if (vm.bankError != null)
                        Text(
                          vm.bankError!,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              ?.copyWith(color: Colors.red),
                        ),
                      const SizedBox(height: 12),
                      Text(
                        'Account Name',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 4),
                      InputField(
                        initialValue: vm.accountName,
                        focusNode: nameFocusNode,
                        onChanged: vm.onAccountNameChanged,
                        validator: vm.accountNameValidator,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            ?.copyWith(color: Colors.black),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Account Number',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 4),
                      InputField(
                        initialValue: vm.accountNumber,
                        focusNode: numberFocusNode,
                        keyboardType: TextInputType.number,
                        onChanged: vm.onAccountNumberChanged,
                        validator: vm.accountNumberValidator,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            ?.copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                child: AppButton.filled(
                  text: vm.initialAccount == null
                      ? 'Add Bank Account'
                      : 'Edit Bank Account',
                  onPressed: vm.onAddPaymentAccount,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
