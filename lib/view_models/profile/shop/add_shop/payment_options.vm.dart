import 'package:flutter/cupertino.dart';

import '../../../../models/bank_code.dart';
import '../../../../routers/app_router.dart';
import '../../../../screens/profile/add_shop/add_bank.dart';
import '../../../../state/view_model.dart';

class SetupPaymentOptionsViewModel extends ViewModel {
  SetupPaymentOptionsViewModel({required this.onSubmit});
  final void Function() onSubmit;

  void onAddBank() {
    AppRouter.profileNavigatorKey.currentState
        ?.push(CupertinoPageRoute(builder: (_) => AddBank()));
  }

  void onAddWallet() {
    AppRouter.profileNavigatorKey.currentState?.push(
      CupertinoPageRoute(
        builder: (_) => AddBank(
          type: BankType.wallet,
        ),
      ),
    );
  }
}