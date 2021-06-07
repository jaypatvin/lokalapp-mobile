import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lokalapp/services/lokal_api_service.dart';
import 'package:provider/provider.dart';

class ChatProvider extends ChangeNotifier {
  String _communityId;
  List<ChatProvider> _chat = [];
  bool _isLoading;

  bool get isLoading => _isLoading;
  List<ChatProvider> get message {
    return [...message];
  }

  String get communityId => _communityId;

  void setCommunityId(String id) {
    _communityId = id;
  }

  Future<bool> create(String idToken, Map data) async {
    try {
      var response = await LokalApiService.instance.chat
          .create(data: data, idToken: idToken);

      if (response.statusCode != 200) return false;

      Map body = json.decode(response.body);

      if (body['status'] == 'ok') {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
