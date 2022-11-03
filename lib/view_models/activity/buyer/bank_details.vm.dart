import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../models/app_navigator.dart';
import '../../../models/bank_code.dart';
import '../../../models/failure_exception.dart';
import '../../../models/order.dart';
import '../../../models/payment_option.dart';
import '../../../models/post_requests/orders/order_pay.request.dart';
import '../../../providers/shops.dart';
import '../../../routers/app_router.dart';
import '../../../screens/activity/buyer/processing_payment.dart';
import '../../../services/api/api.dart';
import '../../../services/api/order_api_service.dart';
import '../../../services/local_image_service.dart';
import '../../../state/view_model.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/media_utility.dart';

class BankDetailsViewModel extends ViewModel {
  BankDetailsViewModel({required this.order, required this.paymentMode});
  final Order order;
  final PaymentMethod paymentMode;

  File? _proofOfPayment;
  File? get proofOfPayment => _proofOfPayment;

  late final MediaUtility _mediaUtility;
  late final LocalImageService _imageService;
  late final OrderAPIService _apiService;

  late final List<PaymentOption> paymentAccounts;

  double get price =>
      order.products.fold(0.0, (double prev, product) => prev + product.price);

  @override
  void init() {
    _apiService = OrderAPIService(context.read<API>());
    _mediaUtility = context.read<MediaUtility>();
    _imageService = context.read<LocalImageService>();

    final shop = context.read<Shops>().findById(order.shopId);
    if (paymentMode == PaymentMethod.eWallet) {
      paymentAccounts = shop?.paymentOptions
              ?.where((bank) => bank.type == BankType.wallet)
              .toList() ??
          <PaymentOption>[];
    } else {
      paymentAccounts = shop?.paymentOptions
              ?.where((bank) => bank.type == BankType.bank)
              .toList() ??
          <PaymentOption>[];
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

      final url = await _imageService.uploadImage(
        file: proofOfPayment!,
        src: kOrderImagesSrc,
      );

      final success = await _apiService.pay(
        orderId: order.id,
        request: OrderPayRequest(
          paymentMethod: paymentMode,
          proofOfPayment: url,
        ),
      );

      if (!success) throw 'Error in submitting image! Try again.';

      AppRouter.activityNavigatorKey.currentState?.push(
        AppNavigator.appPageRoute(
          builder: (_) => ProcessingPayment(
            order: order,
            paymentMode: paymentMode,
          ),
        ),
      );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }
}
