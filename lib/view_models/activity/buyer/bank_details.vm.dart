import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../models/order.dart';
import '../../../models/payment_options.dart';
import '../../../providers/shops.dart';
import '../../../routers/app_router.dart';
import '../../../screens/activity/buyer/processing_payment.dart';
import '../../../services/api/api.dart';
import '../../../services/api/order_api_service.dart';
import '../../../services/local_image_service.dart';
import '../../../state/view_model.dart';
import '../../../utils/utility.dart';

class BankDetailsViewModel extends ViewModel {
  BankDetailsViewModel({required this.order, required this.paymentMode});
  final Order order;
  final PaymentMode paymentMode;

  File? _proofOfPayment;
  File? get proofOfPayment => _proofOfPayment;

  final _mediaUtility = MediaUtility.instance!;
  final _imageService = LocalImageService.instance!;
  late final OrderAPIService _apiService;

  late final List<BankAccount> paymentAccounts;

  double get price =>
      order.products.fold(0.0, (double prev, product) => prev + product.price!);

  @override
  void init() {
    _apiService = OrderAPIService(context.read<API>());

    final shop = context.read<Shops>().findById(order.shopId!);
    if (paymentMode == PaymentMode.gCash) {
      paymentAccounts =
          shop?.paymentOptions?.gCashAccounts ?? <WalletAccount>[];
    } else {
      paymentAccounts = shop?.paymentOptions?.bankAccounts ?? <BankAccount>[];
    }
  }

  Future<void> onImagePick() async {
    final photo = await _mediaUtility.showMediaDialog(context);

    if (photo != null) {
      _proofOfPayment = photo;
      notifyListeners();
    }
  }

  Future<void> onSubmit() async {
    try {
      if (proofOfPayment == null) throw 'No image selected!';

      final _url = await _imageService.uploadImage(
        file: this.proofOfPayment!,
        name: "proof_of_payment",
      );

      final success = await _apiService.pay(
        orderId: this.order.id!,
        body: <String, String>{
          'payment_method': paymentMode.value,
          'proof_of_payment': _url,
        },
      );

      if (!success) throw 'Error in submitting image! Try again.';

      // The ProcessingPaymentScreen returns a boolean on successful
      // payment. If it is, we pop this and go back to the Activity screen.
      AppRouter.activityNavigatorKey.currentState?.push(
        CupertinoPageRoute(
          builder: (_) => ProcessingPayment(
            order: order,
            paymentMode: paymentMode,
          ),
        ),
      );
    } catch (e) {
      showToast(e.toString());
      log(e.toString());
    }
  }
}