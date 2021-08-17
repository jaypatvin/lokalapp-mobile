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

  // --GET
  Future<http.Response> getChatByMembers({
    @required String idToken,
    @required List<String> members,
  }) async {
    String url = "$baseUrl/getChatByMemberIds?";
    members.forEach((member) {
      if (member == members[0]) {
        url += "memberIds=$member";
        return;
      }
      url += "&memberIds=$member";
    });

    return await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
    );
  }

  // --POST
  Future<http.Response> create({
    @required Map data,
    @required String idToken,
  }) async {
    var body = json.encode(data);
    return await http.post(
      "$chatsUrl",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );
  }

  Future<http.Response> createConversation({
    @required String chatId,
    @required Map data,
    @required String idToken,
  }) async {
    var body = json.encode(data);
    return await http.post(
      "$chatsUrl/$chatId/conversation",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken",
      },
      body: body,
    );
  }

  // --PUT
  Future<http.Response> updateTitle({
    @required Map data,
    @required String id,
    @required String idToken,
  }) async {
    var body = json.encode(data);
    return await http.put(
      "$chatsUrl/$id/updateTitle",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken",
      },
      body: body,
    );
  }

  Future<http.Response> invite({
    @required Map data,
    @required String id,
    @required String idToken,
  }) async {
    var body = json.encode(data);
    return await http.put(
      "$chatsUrl/$id/invite",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );
  }

  Future<http.Response> removeUser({
    @required Map data,
    @required String id,
    @required String idToken,
  }) async {
    var body = json.encode(data);
    return await http.put(
      "$chatsUrl/$id/removeUser",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );
  }

  // --DELETE
  Future<http.Response> deleteMessage({
    @required String chatId,
    @required String messageId,
    @required String idToken,
  }) async {
    return await http.delete("$chatsUrl/$chatId/conversation/$messageId",
        headers: {"Authorization": "Bearer $idToken"});
  }
}
