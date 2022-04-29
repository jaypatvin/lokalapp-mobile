import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

import '../../../../app/app.locator.dart';
import '../../../../providers/auth.dart';
import '../../../../services/api/api.dart';

class ChatSettingsViewModel extends ChangeNotifier {
  ChatSettingsViewModel(this.auth);

  final UserAPI _userAPIService = locator<UserAPI>();
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
