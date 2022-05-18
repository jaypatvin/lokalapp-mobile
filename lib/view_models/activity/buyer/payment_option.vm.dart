import 'package:provider/provider.dart';

import '../../../models/app_navigator.dart';
import '../../../models/bank_code.dart';
import '../../../models/order.dart';
import '../../../models/payment_option.dart';
import '../../../providers/shops.dart';
import '../../../routers/app_router.dart';
import '../../../screens/activity/buyer/bank_details.dart';
import '../../../screens/activity/buyer/cash_on_delivery.dart';
import '../../../state/view_model.dart';

class PaymentOptionViewModel extends ViewModel {
  PaymentOptionViewModel(this.order);
  final Order order;

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
        AppRouter.activityNavigatorKey.currentState?.push(
          AppNavigator.appPageRoute(
            builder: (_) => BankDetails(
              order: order,
              paymentMethod: paymentMode,
            ),
          ),
        );
        break;
      case PaymentMethod.cod:
        AppRouter.activityNavigatorKey.currentState?.push(
          AppNavigator.appPageRoute(
            builder: (_) => CashOnDelivery(order: order),
          ),
        );
        break;
    }
  }
}
