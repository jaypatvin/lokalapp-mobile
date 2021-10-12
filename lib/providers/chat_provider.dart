import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';

import '../models/chat_model.dart';
import '../models/conversation.dart';
import '../services/local_image_service.dart';
import '../services/lokal_api/chat_service.dart';

class ChatProvider {
  final _service = ChatService();
  String _idToken;

  void setIdToken(String id) {
    _idToken = id;
  }

  Future<ChatModel> getChatByMembers(List<String> members) async {
    final response = await _service.getChatByMembers(
      idToken: _idToken,
      members: members,
    );

    if (response.statusCode != 200) throw response.reasonPhrase;

    final Map<String, dynamic> body = json.decode(response.body);

    if (body["status"] != "ok") throw (body["data"]);

    return ChatModel.fromMap(body["data"]);
  }

  Future<Conversation> sendMessage({
    @required String chatId,
    @required String userId,
    String replyId,
    String message,
    List<AssetEntity> assets = const [],
  }) async {
    final media = await _getMedia(assets);

    final Map<String, dynamic> data = {
      "user_id": userId,
      "reply_to": replyId,
      "message": message,
      "media": media,
    };
    final response = await _service.createConversation(
      chatId: chatId,
      data: data,
      idToken: _idToken,
    );

    if (response.statusCode != 200) throw (response.reasonPhrase);
    final Map<String, dynamic> _body = jsonDecode(response.body);
    if (_body["status"] != "ok") throw (_body["data"]);

    return Conversation.fromMap(_body["data"]);
  }

  Future<ChatModel> createNewChat({
    @required String userId,
    @required List<String> members,
    String shopId,
    String productId,
    String replyId,
    String message,
    List<AssetEntity> assets = const [],
  }) async {
    final media = await _getMedia(assets);
    final Map<String, dynamic> data = {
      "user_id": userId,
      "reply_to": replyId,
      "message": message,
      "media": media,
      "members": members,
      "shop_id": shopId,
      "product_id": productId,
    };

    final response = await _service.create(data: data, idToken: _idToken);
    if (response.statusCode != 200) throw response.reasonPhrase;

    final Map<String, dynamic> _body = jsonDecode(response.body);
    if (_body["status"] != "ok") throw (_body["data"]);

    return ChatModel.fromMap(_body["data"]);
  }

  Future<void> deleteMessage({
    @required String chatId,
    @required String messageId,
  }) async {
    final response = await _service.deleteMessage(
      chatId: chatId,
      messageId: messageId,
      idToken: _idToken,
    );

    if (response.statusCode != 200) throw (response.statusCode);

    final Map<String, dynamic> _body = jsonDecode(response.body);
    if (_body["status"] != "ok") throw ("Error deleting message.");
  }

  // separate model
  Future<List<Map<String, dynamic>>> _getMedia(List<AssetEntity> assets) async {
    final _imageService = LocalImageService.instance;
    final media = <Map<String, dynamic>>[];

    for (int index = 0; index < assets.length; index++) {
      final asset = assets[index];
      final file = await asset.file;
      final url = await _imageService.uploadImage(
        file: file,
        name: 'post_photo',
      );
      media.add({
        "url": url,
        "type": "image",
        "order": index,
      });
    }
    return media;
  }
}
