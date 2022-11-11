import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recase/recase.dart';

part 'notification_settings.freezed.dart';
part 'notification_settings.g.dart';

enum NotificationType {
  comments,
  communityAlerts,
  likes,
  messages,
  orderStatus,
  subscriptions,
  tags,
}

extension NotificationTypesExtenstion on NotificationType {
  String get value => toString().split('.').last.snakeCase;
}

@freezed
class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    @Default(true) bool comments,
    @Default(true) bool communityAlerts,
    @Default(true) bool likes,
    @Default(true) bool messages,
    @Default(true) bool orderStatus,
    @Default(true) bool subscriptions,
    @Default(true) bool tags,
  }) = _NotificationSettings;

  const NotificationSettings._();

  bool? getProp(String key) => classMap[key];

  UnmodifiableMapView<NotificationType, bool> get classMap {
    return UnmodifiableMapView<NotificationType, bool>({
      NotificationType.comments: comments,
      NotificationType.communityAlerts: communityAlerts,
      NotificationType.likes: likes,
      NotificationType.messages: messages,
      NotificationType.orderStatus: orderStatus,
      NotificationType.subscriptions: subscriptions,
      NotificationType.tags: tags,
    });
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);
}
