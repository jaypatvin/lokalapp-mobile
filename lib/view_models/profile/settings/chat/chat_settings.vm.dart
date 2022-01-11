import 'package:flutter/cupertino.dart';

import '../../../../models/lokal_user.dart';
import '../../../../services/api/user_api_service.dart';

class ChatSettingsViewModel extends ChangeNotifier {
  ChatSettingsViewModel(this.user, this._userAPIService);

  final UserAPIService _userAPIService;
  final LokalUser user;

  bool get showReadReceipts => user.showReadReceipts;

  Future<bool> toggleReadReceipt({required bool value}) async {
    final body = {'show_read_receipts': value};
    try {
      user.showReadReceipts = value;
      notifyListeners();
      final success = await _userAPIService.updateChatSettings(
        userId: user.id!,
        body: body,
      );
      return success;
    } catch (e) {
      user.showReadReceipts = !value;
      notifyListeners();
      rethrow;
    }
  }
}
