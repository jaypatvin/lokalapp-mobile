import 'dart:collection';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:recase/recase.dart';

import '../../../../models/lokal_user.dart';
import '../../../../screens/profile/settings/notification_settings/model/notification_setting.model.dart';
import '../../../../services/api/user_api_service.dart';
import '../../../../services/database.dart';

class NotificationSettingViewModel extends ChangeNotifier {
  NotificationSettingViewModel(this.user, this._userAPIService);

  final UserAPIService _userAPIService;
  final LokalUser user;
  final _notificationTypes = <String, NotificationSettingModel>{};

  bool _isLoading = false;

  UnmodifiableMapView<String, NotificationSettingModel> get notificationTypes =>
      UnmodifiableMapView(_notificationTypes);
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    final querySnapshots = await Database.instance.getNotificationTypes();
    for (final doc in querySnapshots.docs) {
      _notificationTypes[doc.id] = NotificationSettingModel(
        key: doc.id,
        name: doc.id.titleCase,
        description: doc.data()['description'] ?? '',
        value: user.notificationSettings[doc.id] ?? true,
      );
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleNotifications(
    String key, {
    required bool value,
  }) async {
    final body = {key: value};
    bool success = false;
    try {
      _notificationTypes[key]!.value = value;
      user.notificationSettings[key] = value;
      notifyListeners();
      success = await _userAPIService.updateNotficationSettings(
        userId: user.id!,
        body: body,
      );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    } finally {
      if (!success) {
        _notificationTypes[key]!.value = !value;
        notifyListeners();
      }
    }
  }
}
