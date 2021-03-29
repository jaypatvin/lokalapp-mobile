import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'lokal_api_constants.dart';

class InviteService {
  static InviteService _instance;
  static InviteService get instance {
    if (_instance == null) {
      _instance = InviteService();
    }
    return _instance;
  }

  Future<http.Response> check(
      {@required String code, @required String idToken}) async {
    return await http.get("$inviteUrl/check/$code",
        headers: {"Authorization": "Bearer $idToken"});
  }

  Future<http.Response> claim({
    @required String userId,
    @required String code,
    @required String email,
    @required String idToken,
  }) async {
    String body = json.encode(
      {
        "user_id": userId,
        "code": code,
      },
    );
    return await http.post(
      "$inviteUrl/claim",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: body,
    );
  }
}
