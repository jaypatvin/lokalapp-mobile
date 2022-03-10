import 'dart:collection';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../../../../models/notification_settings.dart';
import '../../../../providers/auth.dart';
import '../../../../services/api/user_api_service.dart';

// class NotificationSettingsScreenViewModel extends ViewModel {
//   late final UserAPIService _userAPIService;
//   late final Auth _auth;

//   UnmodifiableMapView<NotificationType, bool?> get notifications =>
//       _auth.user!.notificationSettings.classMap;

//   @override
//   void init() {
//     _userAPIService = UserAPIService(context.read<API>());
//     _auth = context.read<Auth>();
//   }

//   Future<void> toggleNotifications(
//     NotificationType key, {
//     required bool value,
//   }) async {
//     final body = {key.value: value};
//     bool success = false;

//     try {
//       _updateLocally(key, value);
//       notifyListeners();
//       success = await _userAPIService.updateNotficationSettings(
//         userId: _auth.user!.id,
//         body: body,
//       );
//     } catch (e, stack) {
//       FirebaseCrashlytics.instance.recordError(e, stack);
//     } finally {
//       if (!success) {
//         _updateLocally(key, value);
//         notifyListeners();
//       }
//     }
//   }

//   void _updateLocally(NotificationType key, bool value) {
//     final _notificationSettings = _auth.user!.notificationSettings;
//     switch (key) {
//       case NotificationType.comments:
//         _auth.updateNotificationSettings(
//           notificationSettings: _notificationSettings.copyWith(comments: value),
//         );
//         break;
//       case NotificationType.communityAlerts:
//         _auth.updateNotificationSettings(
//           notificationSettings: _notificationSettings.copyWith(
//             communityAlerts: value,
//           ),
//         );
//         break;
//       case NotificationType.likes:
//         _auth.updateNotificationSettings(
//           notificationSettings: _notificationSettings.copyWith(likes: value),
//         );
//         break;
//       case NotificationType.messages:
//         _auth.updateNotificationSettings(
//           notificationSettings: _notificationSettings.copyWith(messages: value),
//         );
//         break;
//       case NotificationType.orderStatus:
//         _auth.updateNotificationSettings(
//           notificationSettings: _notificationSettings.copyWith(
//             orderStatus: value,
//           ),
//         );
//         break;
//       case NotificationType.subscriptions:
//         _auth.updateNotificationSettings(
//           notificationSettings: _notificationSettings.copyWith(
//             subscriptions: value,
//           ),
//         );
//         break;
//       case NotificationType.tags:
//         _auth.updateNotificationSettings(
//           notificationSettings: _notificationSettings.copyWith(tags: value),
//         );
//         break;
//     }
//   }
// }

class NotificationSettingViewModel extends ChangeNotifier {
  NotificationSettingViewModel({
    required this.auth,
    required this.userAPIService,
  });

  final UserAPIService userAPIService;
  final Auth auth;

  UnmodifiableMapView<NotificationType, bool?> get notifications =>
      auth.user!.notificationSettings.classMap;

  Future<void> toggleNotifications(
    NotificationType key, {
    required bool value,
  }) async {
    final body = {key.value: value};
    bool success = false;

    try {
      _updateLocally(key, value);
      notifyListeners();
      success = await userAPIService.updateNotficationSettings(
        userId: auth.user!.id,
        body: body,
      );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    } finally {
      if (!success) {
        _updateLocally(key, value);
        notifyListeners();
      }
    }
  }

  void _updateLocally(NotificationType key, bool value) {
    final _notificationSettings = auth.user!.notificationSettings;
    switch (key) {
      case NotificationType.comments:
        auth.updateNotificationSettings(
          notificationSettings: _notificationSettings.copyWith(comments: value),
        );
        break;
      case NotificationType.communityAlerts:
        auth.updateNotificationSettings(
          notificationSettings: _notificationSettings.copyWith(
            communityAlerts: value,
          ),
        );
        break;
      case NotificationType.likes:
        auth.updateNotificationSettings(
          notificationSettings: _notificationSettings.copyWith(likes: value),
        );
        break;
      case NotificationType.messages:
        auth.updateNotificationSettings(
          notificationSettings: _notificationSettings.copyWith(messages: value),
        );
        break;
      case NotificationType.orderStatus:
        auth.updateNotificationSettings(
          notificationSettings: _notificationSettings.copyWith(
            orderStatus: value,
          ),
        );
        break;
      case NotificationType.subscriptions:
        auth.updateNotificationSettings(
          notificationSettings: _notificationSettings.copyWith(
            subscriptions: value,
          ),
        );
        break;
      case NotificationType.tags:
        auth.updateNotificationSettings(
          notificationSettings: _notificationSettings.copyWith(tags: value),
        );
        break;
    }
  }
}
