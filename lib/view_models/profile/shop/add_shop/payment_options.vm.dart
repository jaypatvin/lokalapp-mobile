import '../../../../models/app_navigator.dart';
import '../../../../models/bank_code.dart';
import '../../../../routers/app_router.dart';
import '../../../../screens/profile/add_shop/add_bank.dart';
import '../../../../state/view_model.dart';

class SetupPaymentOptionsViewModel extends ViewModel {
  SetupPaymentOptionsViewModel({required this.onSubmit, required this.edit});
  final void Function() onSubmit;
  final bool edit;

  void onAddBank() {
    AppRouter.profileNavigatorKey.currentState?.push(
      AppNavigator.appPageRoute(
        builder: (_) => AddBank(
          edit: edit,
        ),
      ),
    );
  }

  void onAddWallet() {
    AppRouter.profileNavigatorKey.currentState?.push(
      AppNavigator.appPageRoute(
        builder: (_) => AddBank(
          type: BankType.wallet,
          edit: edit,
        ),
      ),
    );
  }
}
