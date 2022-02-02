import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

import '../../../../models/lokal_user.dart';
import '../../../../services/api/user_api_service.dart';

class ChatSettingsViewModel extends ChangeNotifier {
  ChatSettingsViewModel(this.user, this._userAPIService);

  final UserAPIService _userAPIService;
  final LokalUser user;

  bool get showReadReceipts => user.showReadReceipts;

  Future<void> toggleReadReceipt({required bool value}) async {
    final body = {'show_read_receipts': value};
    bool success = false;
    try {
      user.showReadReceipts = value;
      notifyListeners();
      success = await _userAPIService.updateChatSettings(
        userId: user.id!,
        body: body,
      );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    } finally {
      if (!success) {
        user.showReadReceipts = !value;
        notifyListeners();
      }
    }
  }
}
