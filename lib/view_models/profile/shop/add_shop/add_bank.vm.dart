import '../../../../app/app.locator.dart';
import '../../../../app/app.router.dart';
import '../../../../app/app_router.dart';
import '../../../../models/bank_code.dart';
import '../../../../models/payment_option.dart';
import '../../../../providers/bank_codes.dart';
import '../../../../state/view_model.dart';

class AddBankViewModel extends ViewModel {
  AddBankViewModel(
    this._bankCodes,
    this._bankType, {
    this.edit = false,
  });
  final BankCodes _bankCodes;
  final BankType _bankType;
  final bool edit;

  BankType get bankType => _bankType;

  late final String header;
  late final String addButtonLabel;

  final _appRouter = locator<AppRouter>();

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
    _appRouter.navigateTo(
      AppRoute.profile,
      ProfileScreenRoutes.addBankDetails,
      arguments: AddBankDetailsArguments(bankType: _bankType, edit: edit),
    );
  }

  void onEditBankDetails(PaymentOption account) {
    _appRouter.navigateTo(
      AppRoute.profile,
      ProfileScreenRoutes.addBankDetails,
      arguments: AddBankDetailsArguments(
        bankAccount: account,
        bankType: _bankType,
        edit: edit,
      ),
    );
  }

  void onBackToPaymentOptions() {
    _appRouter.popScreen(AppRoute.profile);
  }
}
