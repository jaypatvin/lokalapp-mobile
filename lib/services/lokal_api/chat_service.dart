import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'lokal_api_constants.dart';

class ChatService {
  static ChatService _instance;

  static ChatService get instance {
    if (_instance == null) {
      _instance = ChatService();
    }
    return _instance;
  }

  // --POST
  Future<http.Response> create(
      {@required Map data, @required String idToken}) async {
    var body = json.encode(data);
    var response = await http.post(
      "$chatsUrl",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );

    return response;
  }

  // --DELETE
  Future<http.Response> delete(
      {@required String chatId, @required String idToken}) async {
    return await http.delete('$chatsUrl/$chatId',
        headers: {"Authorization": "Bearer $idToken"});
  }
}
