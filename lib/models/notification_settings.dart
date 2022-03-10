import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:recase/recase.dart';

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

@JsonSerializable()
class NotificationSettings {
  const NotificationSettings({
    this.likes = true,
    this.comments = true,
    this.tags = true,
    this.messages = true,
    this.orderStatus = true,
    this.communityAlerts = true,
    this.subscriptions = true,
  });

  final bool comments;
  final bool communityAlerts;
  final bool likes;
  final bool messages;
  final bool orderStatus;
  final bool subscriptions;
  final bool tags;

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

  NotificationSettings copyWith({
    bool? likes,
    bool? comments,
    bool? tags,
    bool? messages,
    bool? orderStatus,
    bool? communityAlerts,
    bool? subscriptions,
  }) {
    return NotificationSettings(
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      tags: tags ?? this.tags,
      messages: messages ?? this.messages,
      orderStatus: orderStatus ?? this.orderStatus,
      communityAlerts: communityAlerts ?? this.communityAlerts,
      subscriptions: subscriptions ?? this.subscriptions,
    );
  }

  Map<String, dynamic> toJson() => _$NotificationSettingsToJson(this);
  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);

  @override
  String toString() {
    return 'NotificationSettings(likes: $likes, comments: $comments, '
        'tags: $tags, messages: $messages, orderStatus: $orderStatus, '
        'communityAlerts: $communityAlerts, subscriptions: $subscriptions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationSettings &&
        other.likes == likes &&
        other.comments == comments &&
        other.tags == tags &&
        other.messages == messages &&
        other.orderStatus == orderStatus &&
        other.communityAlerts == communityAlerts &&
        other.subscriptions == subscriptions;
  }

  @override
  int get hashCode {
    return likes.hashCode ^
        comments.hashCode ^
        tags.hashCode ^
        messages.hashCode ^
        orderStatus.hashCode ^
        communityAlerts.hashCode ^
        subscriptions.hashCode;
  }
}
