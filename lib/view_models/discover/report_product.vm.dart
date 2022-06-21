import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../models/app_navigator.dart';
import '../../models/post_requests/shared/report.dart';
import '../../routers/app_router.dart';
import '../../screens/discover/discover.dart';
import '../../services/api/api.dart';
import '../../services/api/product_api_service.dart';
import '../../state/view_model.dart';
import '../../widgets/report_sent.dart';

class ReportProductViewModel extends ViewModel {
  ReportProductViewModel({required this.productId});

  final String productId;

  String _reportMessage = '';
  String get reportMessage => _reportMessage;

  late final ProductApiService _apiService;

  @override
  void init() {
    _apiService = ProductApiService(context.read<API>());
  }

  void onReportMessageChanged(String value) {
    _reportMessage = value;
    notifyListeners();
  }

  Future<void> onSubmit() async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      final success = await _apiService.report(
        productId: productId,
        report: Report(description: _reportMessage),
      );

      if (success) {
        AppRouter.discoverNavigatorKey.currentState?.pushReplacement(
          AppNavigator.appPageRoute(
            builder: (_) => ReportSent(
              onConfirm: () =>
                  AppRouter.discoverNavigatorKey.currentState?.popUntil(
                ModalRoute.withName(Discover.routeName),
              ),
            ),
          ),
        );
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast('There was an error submitting the report, please try again.');
    }
  }
}
