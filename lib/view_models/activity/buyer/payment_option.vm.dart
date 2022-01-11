import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../models/order.dart';
import '../../../models/payment_options.dart';
import '../../../providers/shops.dart';
import '../../../routers/app_router.dart';
import '../../../screens/activity/buyer/bank_details.dart';
import '../../../screens/activity/buyer/cash_on_delivery.dart';
import '../../../screens/activity/buyer/processing_payment.dart';
import '../../../state/view_model.dart';

class PaymentOptionViewModel extends ViewModel {
  PaymentOptionViewModel(this.order);
  final Order order;

  late final PaymentOptions _paymentOptions;

  bool get bankEnabled => _paymentOptions.bankAccounts.isNotEmpty;
  bool get walletEnabled => _paymentOptions.gCashAccounts.isNotEmpty;

  @override
  void init() {
    _paymentOptions =
        context.read<Shops>().findById(order.shopId)?.paymentOptions ??
            const PaymentOptions();
  }

  void onPaymentPressed(PaymentMode paymentMode) {
    switch (paymentMode) {
      case PaymentMode.bank:
      case PaymentMode.gCash:
        AppRouter.activityNavigatorKey.currentState?.push<bool?>(
          CupertinoPageRoute(
            builder: (context) => BankDetails(
              paymentMode: paymentMode,
              order: order,
            ),
          ),
        );

        break;
      case PaymentMode.cash:
        AppRouter.activityNavigatorKey.currentState?.push<bool?>(
          CupertinoPageRoute(
            builder: (context) => CashOnDelivery(
              order: order,
            ),
          ),
        );
        break;
    }
  }
}
