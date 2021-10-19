import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

enum MainScreen {
  home,
  discover,
  chats,
  activity,
  profile,
}

class UserSharedPreferences {
  late final SharedPreferences? _preference;
  final _streamController = StreamController<UserSharedPreferences>.broadcast();

  static const _keys = const <MainScreen, String>{
    MainScreen.home: 'onboard_home',
    MainScreen.discover: 'onboard_discover',
    MainScreen.chats: 'onboard_chats',
    MainScreen.activity: 'onboard_activity',
    MainScreen.profile: 'onboard_profile',
  };

  Stream<UserSharedPreferences> get stream => _streamController.stream;
  void dispose() {
    _streamController.close();
  }

  bool get isReady => _preference != null;
  Future<bool> init() async {
    _streamController.add(this);
    _preference = await SharedPreferences.getInstance();
    _streamController.add(this);
    return isReady;
  }

  String getOnboardingKey(MainScreen screen) {
    return _keys[screen]!;
  }

  bool getOnboardingStatus(MainScreen screen) {
    return _preference?.getBool(_keys[screen]!) ?? false;
  }

  Future<void> updateOnboardingStatus(
    MainScreen screen, [
    bool status = true,
  ]) async {
    if (!isReady) await init();
    _preference!.setBool(_keys[screen]!, status);
    _streamController.add(this);
  }
}
