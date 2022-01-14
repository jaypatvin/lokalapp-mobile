import 'package:flutter/cupertino.dart';

import '../../../../models/bank_code.dart';
import '../../../../models/payment_option.dart';
import '../../../../providers/bank_codes.dart';
import '../../../../routers/app_router.dart';
import '../../../../screens/profile/add_shop/add_bank_details.dart';
import '../../../../state/view_model.dart';

class AddBankViewModel extends ViewModel {
  AddBankViewModel(this._bankCodes, this._bankType);
  final BankCodes _bankCodes;
  final BankType _bankType;

  BankType get bankType => _bankType;

  late final String header;
  late final String addButtonLabel;

  @override
  void init() {
    if (_bankType == BankType.bank) {
      header = 'Bank Transfer/Deposit Options';
      addButtonLabel = '+ Add bank details';
    } else {
      header = 'Wallet Transfer/Deposit Options';
      addButtonLabel = '+ Add Wallet details';
    }
  }

  String getBankName(String id) => _bankCodes.getById(id).name;

  List<PaymentOption> items(List<PaymentOption>? paymentOptions) {
    return paymentOptions?.where((bank) => bank.type == _bankType).toList() ??
        const [];
  }

  void onAddBankDetails() {
    AppRouter.profileNavigatorKey.currentState?.push(
      CupertinoPageRoute(
        builder: (_) => AddBankDetails(
          bankType: _bankType,
        ),
      ),
    );
  }

  void onEditBankDetails(PaymentOption account) {
    AppRouter.profileNavigatorKey.currentState?.push(
      CupertinoPageRoute(
        builder: (_) => AddBankDetails(
          bankAccount: account,
          bankType: _bankType,
        ),
      ),
    );
  }

  void onBackToPaymentOptions() {
    AppRouter.profileNavigatorKey.currentState?.pop();
  }
}
