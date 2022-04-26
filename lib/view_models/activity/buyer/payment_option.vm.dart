import 'package:provider/provider.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../app/app_router.dart';
import '../../../models/bank_code.dart';
import '../../../models/order.dart';
import '../../../models/payment_option.dart';
import '../../../providers/shops.dart';
import '../../../state/view_model.dart';

class PaymentOptionViewModel extends ViewModel {
  PaymentOptionViewModel(this.order);
  final Order order;

  final _appRouter = locator<AppRouter>();

  late final List<PaymentOption> _paymentOptions;

  bool get bankEnabled =>
      _paymentOptions.where((bank) => bank.type == BankType.bank).isNotEmpty;

  bool get walletEnabled =>
      _paymentOptions.where((bank) => bank.type == BankType.wallet).isNotEmpty;

  double get totalPayment =>
      order.products.fold(0.0, (double prev, product) => prev + product.price);

  @override
  void init() {
    _paymentOptions =
        context.read<Shops>().findById(order.shopId)?.paymentOptions ??
            const [];
  }

  void onPaymentPressed(PaymentMethod paymentMode) {
    switch (paymentMode) {
      case PaymentMethod.bank:
      case PaymentMethod.eWallet:
        _appRouter.navigateTo(
          AppRoute.activity,
          ActivityRoutes.bankDetails,
          arguments: BankDetailsArguments(
            order: order,
            paymentMethod: paymentMode,
          ),
        );
        break;
      case PaymentMethod.cod:
        _appRouter.navigateTo(
          AppRoute.activity,
          ActivityRoutes.cashOnDelivery,
          arguments: CashOnDeliveryArguments(order: order),
        );
        break;
    }
  }
}
