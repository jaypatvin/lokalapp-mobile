import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../services/lokal_api_service.dart';

class Invite extends ChangeNotifier {
  String _code;
  bool _isChecking;
  bool _isClaiming;

  String get code => _code;
  bool get isChecking => _isChecking;
  bool get isClaiming => _isClaiming;

  Future<String> check(String inviteCode, String authToken) async {
    _isChecking = true;
    try {
      var response = await LokalApiService.instance.invite
          .check(code: inviteCode, idToken: authToken);
      if (response.statusCode != 200) {
        _isChecking = false;
        notifyListeners();
        return '';
      }

      var data = json.decode(response.body);
      if (data['status'] == 'ok') {
        _code = inviteCode;
        _isChecking = false;
        notifyListeners();
        return data['data']['community_id'];
      }
    } catch (e) {
      _isChecking = false;
      return '';
    }
    notifyListeners();
    return '';
  }

  Future<bool> claim({
    @required String userId,
    @required String email,
    @required String authToken,
  }) async {
    _isClaiming = true;
    try {
      var response = await LokalApiService.instance.invite
          .claim(userId: userId, code: _code, email: email, idToken: authToken);

      if (response.statusCode != 200) {
        _isChecking = false;
        notifyListeners();
        return false;
      }

      var data = json.decode(response.body);
      if (data['status'] == 'ok') {
        _isChecking = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _isChecking = false;
      return false;
    }
    notifyListeners();
    return false;
  }
}
