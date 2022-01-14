import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final _chosenCode = useState<BankCode?>(vm.bank);

    final _nameFocusNode = useFocusNode();
    final _numberFocusNode = useFocusNode();

    useEffect(
      () {
        void _bankListener() => vm.onBankChanged(_chosenCode.value);
        _chosenCode.addListener(_bankListener);

        return () {
          _chosenCode.removeListener(_bankListener);
        };
      },
      [_chosenCode],
    );

    final _androidDropDown = useMemoized<Widget>(
      () {
        final List<DropdownMenuItem<BankCode>> dropDownItems = [];

        for (final code in vm.codes) {
          dropDownItems.add(
            DropdownMenuItem(
              value: code,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: Text(
                  code.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        }

        return DropdownButtonHideUnderline(
          child: DropdownButton<BankCode>(
            hint: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: const Text(
                'Select a Bank',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            value: _chosenCode.value,
            isExpanded: true,
            items: dropDownItems,
            focusColor: Colors.white,
            icon: const Padding(
              padding: EdgeInsets.only(right: 2.0),
              child: Icon(
                MdiIcons.chevronDown,
                color: kTealColor,
              ),
            ),
            iconSize: 24.0.sp,
            onChanged: (value) => _chosenCode.value = value,
          ),
        );
      },
      [_chosenCode.value],
    );

    final _iOSPicker = useMemoized<Widget>(
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
              if (_chosenCode.value == null)
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
              if (_chosenCode.value != null)
                Expanded(
                  child: Text(
                    _chosenCode.value!.name,
                    style: Theme.of(context).textTheme.bodyText2,
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
                  height: 200.h,
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                        textStyle: Theme.of(context).textTheme.bodyText2,
                        actionTextStyle: Theme.of(context).textTheme.bodyText2,
                        pickerTextStyle: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.black, fontSize: 18.0.sp),
                      ),
                    ),
                    child: CupertinoPicker(
                      itemExtent: 32.0.h,
                      onSelectedItemChanged: (index) =>
                          _chosenCode.value = vm.codes[index],
                      children: pickerItems,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      [_chosenCode.value],
    );

    final _kbActionsConfig = useMemoized<KeyboardActionsConfig>(
      () => KeyboardActionsConfig(
        keyboardBarColor: Colors.grey.shade200,
        actions: [
          KeyboardActionsItem(
            focusNode: _nameFocusNode,
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
            focusNode: _numberFocusNode,
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
              config: _kbActionsConfig,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                child: Form(
                  key: vm.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bank Transfer/Deposit Options',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 10.0.h),
                      Text(
                        'Bank',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
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
                        child: Platform.isIOS ? _iOSPicker : _androidDropDown,
                      ),
                      if (vm.bankError != null)
                        Text(
                          vm.bankError!,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              ?.copyWith(color: Colors.red),
                        ),
                      SizedBox(height: 5.0.h),
                      Text(
                        'Account Name',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      InputField(
                        initialValue: vm.accountName,
                        focusNode: _nameFocusNode,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        onChanged: vm.onAccountNameChanged,
                        validator: vm.accountNameValidator,
                      ),
                      SizedBox(height: 5.0.h),
                      Text(
                        'Account Number',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      InputField(
                        initialValue: vm.accountNumber,
                        focusNode: _numberFocusNode,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        onChanged: vm.onAccountNumberChanged,
                        validator: vm.accountNumberValidator,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AppButton(
              vm.initialAccount == null
                  ? 'Add Bank Account'
                  : 'Edit Bank Account',
              kTealColor,
              true,
              vm.onAddPaymentAccount,
            ),
          ),
        ],
      ),
    );
  }
}
