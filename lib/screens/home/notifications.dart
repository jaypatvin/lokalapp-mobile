import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../providers/notifications.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/custom_app_bar.dart';

class Notifications extends HookWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Notifications',
        backgroundColor: kTealColor,
        titleStyle: const TextStyle(color: Colors.white),
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: Consumer<NotificationsProvider>(
        builder: (ctx, notifications, child) {
          if (notifications.stream == null || notifications.items.isEmpty) {
            return const Center(
              child: Text('Yay! No notifications!'),
            );
          }
          final _keys = notifications.items.keys.toList();
          return ListView.separated(
            itemCount: _keys.length,
            separatorBuilder: (ctx3, index) {
              return const Divider();
            },
            itemBuilder: (ctx3, index) {
              final _key = _keys[index];
              final notification = notifications.items[_key]!;
              final difference =
                  DateTime.now().difference(notification.createdAt);
              String _createdSince = '';
              if (difference.inDays >= 1) {
                _createdSince += '${difference.inDays}'
                    ' day${difference.inDays == 1 ? "" : "s"} ago';
              } else if (difference.inHours >= 1) {
                _createdSince += '${difference.inHours}'
                    ' hour${difference.inHours == 1 ? "" : "s"} ago';
              } else if (difference.inMinutes >= 1) {
                _createdSince += '${difference.inMinutes}'
                    ' minute${difference.inMinutes == 1 ? "" : "s"} ago';
              } else {
                _createdSince += '${difference.inSeconds}'
                    ' second${difference.inSeconds == 1 ? "" : "s"} ago';
              }
              return VisibilityDetector(
                key: ValueKey(notification.id),
                onVisibilityChanged: (_) =>
                    notifications.onNotificationSeen(id: notification.id),
                child: ListTile(
                  title: Text(notification.title),
                  subtitle: Text(
                    '${notification.message}\n $_createdSince',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
