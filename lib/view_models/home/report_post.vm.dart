import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../models/app_navigator.dart';
import '../../models/post_requests/shared/report.dart';
import '../../routers/app_router.dart';
import '../../screens/home/home.dart';
import '../../services/api/activity_api_service.dart';
import '../../services/api/api.dart';
import '../../state/view_model.dart';
import '../../widgets/report_sent.dart';

class ReportPostViewModel extends ViewModel {
  ReportPostViewModel({required this.activityId});

  final String activityId;

  String _reportMessage = '';
  String get reportMessage => _reportMessage;

  late final ActivityAPIService _apiService;

  @override
  void init() {
    _apiService = ActivityAPIService(context.read<API>());
  }

  void onReportMessageChanged(String value) {
    _reportMessage = value;
    notifyListeners();
  }

  Future<void> onSubmit() async {
    try {
      final success = await _apiService.report(
        activityId: activityId,
        report: Report(description: _reportMessage),
      );

      if (success) {
        AppRouter.homeNavigatorKey.currentState?.pushReplacement(
          AppNavigator.appPageRoute(
            builder: (_) => ReportSent(
              onConfirm: () =>
                  AppRouter.homeNavigatorKey.currentState?.popUntil(
                ModalRoute.withName(Home.routeName),
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
