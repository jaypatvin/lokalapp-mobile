import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../providers/notifications.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/custom_app_bar.dart';

class Notifications extends HookWidget {
  static const routeName = '/home/notifications';
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
          final keys = notifications.items.keys.toList();
          return ListView.separated(
            itemCount: keys.length,
            separatorBuilder: (ctx3, index) {
              return const Divider();
            },
            itemBuilder: (ctx3, index) {
              final key = keys[index];
              final notification = notifications.items[key]!;
              final difference =
                  DateTime.now().difference(notification.createdAt);
              String createdSince = '';
              if (difference.inDays >= 1) {
                createdSince += '${difference.inDays}'
                    ' day${difference.inDays == 1 ? "" : "s"} ago';
              } else if (difference.inHours >= 1) {
                createdSince += '${difference.inHours}'
                    ' hour${difference.inHours == 1 ? "" : "s"} ago';
              } else if (difference.inMinutes >= 1) {
                createdSince += '${difference.inMinutes}'
                    ' minute${difference.inMinutes == 1 ? "" : "s"} ago';
              } else {
                createdSince += '${difference.inSeconds}'
                    ' second${difference.inSeconds == 1 ? "" : "s"} ago';
              }
              return VisibilityDetector(
                key: ValueKey(notification.id),
                onVisibilityChanged: (_) =>
                    notifications.onNotificationSeen(id: notification.id),
                child: ListTile(
                  title: Text(notification.title),
                  subtitle: Text(
                    '${notification.message}\n $createdSince',
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
