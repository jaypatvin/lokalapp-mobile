import '../../../../app/app.locator.dart';
import '../../../../app/app.router.dart';
import '../../../../app/app_router.dart';
import '../../../../models/bank_code.dart';
import '../../../../state/view_model.dart';

class SetupPaymentOptionsViewModel extends ViewModel {
  SetupPaymentOptionsViewModel({required this.onSubmit, required this.edit});
  final void Function() onSubmit;
  final bool edit;

  final _appRouter = locator<AppRouter>();

  void onAddBank() {
    _appRouter.navigateTo(
      AppRoute.profile,
      ProfileScreenRoutes.addBank,
      arguments: AddBankArguments(edit: edit),
    );
  }

  void onAddWallet() {
    _appRouter.navigateTo(
      AppRoute.profile,
      ProfileScreenRoutes.addBank,
      arguments: AddBankArguments(type: BankType.wallet, edit: edit),
    );
  }
}
