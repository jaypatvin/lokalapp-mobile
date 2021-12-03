import 'package:flutter/cupertino.dart';

import '../../../../models/bank_code.dart';
import '../../../../models/payment_options.dart';
import '../../../../providers/bank_codes.dart';
import '../../../../routers/app_router.dart';
import '../../../../screens/profile/add_shop/add_bank_details.dart';
import '../../../../state/view_model.dart';

class AddBankViewModel extends ViewModel {
  AddBankViewModel(this._bankCodes, this._bankType);
  final BankCodes _bankCodes;
  final BankType _bankType;

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

  List<BankAccount> items(PaymentOptions? paymentOptions) {
    if (_bankType == BankType.bank) {
      return paymentOptions?.bankAccounts ?? <BankAccount>[];
    }

    return paymentOptions?.gCashAccounts ?? <WalletAccount>[];
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

  void onEditBankDetails(BankAccount account) {
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
