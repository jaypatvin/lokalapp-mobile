import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/json_converters/chat_type_converter.dart';
import '../services/json_converters/date_time_converter.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

enum ChatType { user, shop, product }

extension ChatTypeExtension on ChatType {
  String get value {
    switch (this) {
      case ChatType.user:
        return 'user';
      case ChatType.shop:
        return 'shop';
      case ChatType.product:
        return 'product';
    }
  }
}

@freezed
class Message with _$Message {
  const factory Message({
    required String content,
    @DateTimeConverter() required DateTime createdAt,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

@freezed
class ChatModel with _$ChatModel {
  const factory ChatModel({
    required String id,
    required List<String> members,
    required String title,
    @ChatTypeConverter() required ChatType chatType,
    required bool archived,
    required String communityId,
    @DateTimeConverter() required DateTime createdAt,
    required Message lastMessage,
    String? shopId,
    String? customerName,
    String? productId,
  }) = _ChatModel;

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);

  factory ChatModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ChatModel.fromJson({'id': doc.id, ...doc.data()!});
  }
}
