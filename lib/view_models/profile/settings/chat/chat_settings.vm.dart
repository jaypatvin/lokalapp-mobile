import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

import '../../../../providers/auth.dart';
import '../../../../services/api/user_api_service.dart';

class ChatSettingsViewModel extends ChangeNotifier {
  ChatSettingsViewModel(this.auth, this._userAPIService);

  final UserAPIService _userAPIService;
  final Auth auth;

  bool get showReadReceipts => auth.user!.showReadReceipts;

  Future<void> toggleReadReceipt({required bool value}) async {
    final body = {'show_read_receipts': value};
    bool success = false;
    try {
      auth.updateReadReceipts(showReadReceipts: value);
      notifyListeners();
      success = await _userAPIService.updateChatSettings(
        userId: auth.user!.id,
        body: body,
      );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    } finally {
      if (!success) {
        auth.updateReadReceipts(showReadReceipts: !value);
        notifyListeners();
      }
    }
  }
}
