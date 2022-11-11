import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/chat_model.dart';

class ChatTypeConverter implements JsonConverter<ChatType, String> {
  const ChatTypeConverter();

  @override
  ChatType fromJson(String chatType) {
    return ChatType.values.firstWhere(
      (e) => e.value == chatType,
      orElse: () => ChatType.user,
    );
  }

  @override
  String toJson(ChatType type) => type.value;
}
