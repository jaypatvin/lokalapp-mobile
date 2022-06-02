import '../../models/app_navigator.dart';
import '../../routers/app_router.dart';
import '../../screens/home/report_sent.dart';
import '../../state/view_model.dart';

class ReportPostViewModel extends ViewModel {
  String _reportMessage = '';
  String get reportMessage => _reportMessage;

  void onReportMessageChanged(String value) {
    _reportMessage = value;
    notifyListeners();
  }

  Future<void> onSubmit() async {
    await Future.delayed(const Duration(seconds: 2));
    AppRouter.homeNavigatorKey.currentState?.pushReplacement(
      AppNavigator.appPageRoute(builder: (_) => const ReportSent()),
    );
  }
}
