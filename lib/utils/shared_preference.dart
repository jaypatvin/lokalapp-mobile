import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lokalapp/widgets/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  SharedPreferences _preference;
  final _streamController = StreamController<UserSharedPreferences>.broadcast();
  Stream<UserSharedPreferences> get stream => _streamController.stream;
  void dispose() {
    _streamController?.close();
  }

  bool get isReady => _preference != null;
  Future<bool> init() async {
    _streamController.add(this);
    _preference = await SharedPreferences.getInstance();
    _streamController.add(this);
    return isReady;
  }

  // buildStream() {
  //   Stream stream = _streamController.stream;
  //   StreamSubscription<Widget> streamSubscription = stream.listen((value) {
  //     return Onboarding();
  //   });
  //   streamSubscription.cancel();
  // }

  static const String _isHomeKey = 'is_home_app_opened';

  bool get isHome => _preference?.getBool(_isHomeKey) ?? false;
  set isHome(bool value) => updateIsHome(value);

  Future updateIsHome(bool value) async {
    if (!isReady) await init();
    _preference.setBool(_isHomeKey, value);
    _streamController.add(this);
  }

  static const String _isDiscoverKey = 'is_discover_opened';
  bool get isDiscover => _preference?.getBool(_isDiscoverKey) ?? false;
  set isDiscover(bool value) => updateIsDiscover(value);

  Future updateIsDiscover(bool value) async {
    if (!isReady) await init();
    _preference.setBool(_isDiscoverKey, value);
    _streamController.add(this);
  }

  static const String _isChatKey = 'is_chat';
  bool get isChat => _preference?.getBool(_isChatKey) ?? false;
  set isChat(bool value) => updateIsChat(value);

  Future updateIsChat(bool value) async {
    if (!isReady) await init();
    _preference.setBool(_isChatKey, value);
    _streamController.add(this);
  }

  static const String _isActivityKey = 'is_activity';
  bool get isActivity => _preference?.getBool(_isActivityKey) ?? false;
  set isActivity(bool value) => updateIsActivity(value);

  Future updateIsActivity(bool value) async {
    if (!isReady) await init();
    _preference.setBool(_isActivityKey, value);
    _streamController.add(this);
  }

  static const String _isProfileKey = 'is_profile';
  bool get isProfile => _preference?.getBool(_isProfileKey) ?? false;
  set isProfile(bool value) => updateIsProfile(value);

  Future updateIsProfile(bool value) async {
    if (!isReady) await init();
    _preference.setBool(_isProfileKey, value);
    _streamController.add(this);
  }
}
