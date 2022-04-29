import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:oktoast/oktoast.dart';

import '../../app/app.locator.dart';
import '../../app/app_router.dart';
import '../../models/app_navigator.dart';
import '../../models/post_requests/shared/report.dart';
import '../../services/api/api.dart';
import '../../state/view_model.dart';
import '../../widgets/report_sent.dart';

class ReportProductViewModel extends ViewModel {
  ReportProductViewModel({required this.productId});

  final String productId;

  String _reportMessage = '';
  String get reportMessage => _reportMessage;

  final ProductAPI _apiService = locator<ProductAPI>();

  void onReportMessageChanged(String value) {
    _reportMessage = value;
    notifyListeners();
  }

  Future<void> onSubmit() async {
    try {
      final success = await _apiService.report(
        productId: productId,
        report: Report(description: _reportMessage),
      );

      if (success) {
        final _appRouter = locator<AppRouter>();
        final _route = _appRouter.currentTabRoute;
        _appRouter.pushDynamicScreen(
          _route,
          AppNavigator.appPageRoute(
            builder: (_) => const ReportSent(),
          ),
          replace: true,
        );
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast('There was an error submitting the report, please try again.');
    }
  }
}
