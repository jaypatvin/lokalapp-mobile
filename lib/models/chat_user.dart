import 'package:lokalapp/utils/chat_utils.dart';
import 'package:meta/meta.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class ChatUser {
  final String idUser;
  final String name;
  final String urlAvatar;
  final DateTime lastMessageTime;

  const ChatUser({
    this.idUser,
    @required this.name,
    @required this.urlAvatar,
    @required this.lastMessageTime,
  });

  ChatUser copyWith({
    String idUser,
    String name,
    String urlAvatar,
    String lastMessageTime,
  }) =>
      ChatUser(
        idUser: idUser ?? this.idUser,
        name: name ?? this.name,
        urlAvatar: urlAvatar ?? this.urlAvatar,
        lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      );

  static ChatUser fromJson(Map<String, dynamic> json) => ChatUser(
        idUser: json['idUser'],
        name: json['name'],
        urlAvatar: json['urlAvatar'],
        lastMessageTime: Utils.toDateTime(json['lastMessageTime']),
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'name': name,
        'urlAvatar': urlAvatar,
        'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime),
      };
}
