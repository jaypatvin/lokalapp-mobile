import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_invite.request.g.dart';

@JsonSerializable()
class ChatInviteRequest {
  ChatInviteRequest({
    this.userId,
    this.newMembers,
  }) : assert(
          (userId?.isNotEmpty ?? false) || (newMembers?.isNotEmpty ?? false),
          'Either userId or newMembers is required.',
        );

  final String? userId;
  final List<String>? newMembers;

  Map<String, dynamic> toJson() => _$ChatInviteRequestToJson(this);
  factory ChatInviteRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatInviteRequestFromJson(json);

  ChatInviteRequest copyWith({
    String? userId,
    List<String>? newMembers,
  }) {
    return ChatInviteRequest(
      userId: userId ?? this.userId,
      newMembers: newMembers ?? this.newMembers,
    );
  }

  @override
  String toString() =>
      'ChatInviteRequest(userId: $userId, newMembers: $newMembers)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatInviteRequest &&
        other.userId == userId &&
        listEquals(other.newMembers, newMembers);
  }

  @override
  int get hashCode => userId.hashCode ^ newMembers.hashCode;
}
