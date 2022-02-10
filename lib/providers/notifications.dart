import 'dart:async';

import 'package:flutter/material.dart';

import '../models/lokal_notification.dart';
import '../services/database.dart';

class NotificationsProvider extends ChangeNotifier {
  final Database _db = Database.instance;

  String? _userId;
  String? get userId => _userId;

  Stream<List<LokalNotification>>? _stream;
  Stream<List<LokalNotification>>? get stream => _stream;

  // final List<LokalNotification> _notifications = [];
  // List<LokalNotification> get items => _notifications;
  final Map<String, LokalNotification> _notifications = {};
  Map<String, LokalNotification> get items => _notifications;

  StreamSubscription<List<LokalNotification>>? _subscription;

  bool _displayAlert = false;
  bool get displayAlert => _displayAlert;

  void setUserId(String? userId) {
    if (this.userId == userId) {
      // nothing to change here
      return;
    }

    _userId = userId;
    if (userId == null) {
      // this means we have logged out.
      _subscription?.cancel();
      _stream = null;
      notifyListeners();
      return;
    }

    _stream = _db.getUserNotifications(userId).map(
          (snapshot) => snapshot.docs
              .map((doc) => LokalNotification.fromDocument(doc))
              .toList(),
        );
    _subscription = _stream?.listen(_streamListener);

    notifyListeners();
  }

  void onRefresh() {
    if (_userId == null) {
      return;
    }

    _stream = _stream = _db.getUserNotifications(_userId!).map(
          (snapshot) => snapshot.docs
              .map((doc) => LokalNotification.fromDocument(doc))
              .toList(),
        );
  }

  void _streamListener(List<LokalNotification> data) {
    for (final notification in data) {
      _notifications[notification.id] = notification;
    }

    _displayAlert =
        _notifications.values.any((notification) => !notification.viewed);
    notifyListeners();
    // TODO: save latest seen here
  }

  void onNotificationSeen({required String id}) {
    if (_userId == null) return;
    if (_notifications[id]!.viewed) return;

    _db.onNotificationSeen(userId: _userId!, notificationId: id);
  }
}
