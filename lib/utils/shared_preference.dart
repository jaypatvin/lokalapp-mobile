import 'dart:async';

import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MainScreen {
  home,
  discover,
  chats,
  activity,
  profile,
}

class UserSharedPreferences {
  SharedPreferences? _preference;
  final _streamController = StreamController<UserSharedPreferences>.broadcast();
  final _storage = LocalStorage('session');

  static const _onboardingKeys = <MainScreen, String>{
    MainScreen.home: 'onboard_home',
    MainScreen.discover: 'onboard_discover',
    MainScreen.chats: 'onboard_chats',
    MainScreen.activity: 'onboard_activity',
    MainScreen.profile: 'onboard_profile',
  };

  Stream<UserSharedPreferences> get stream => _streamController.stream;
  void dispose() {
    _streamController.close();
    _storage.clear();
    _storage.dispose();
  }

  bool get isReady => _preference != null;
  Future<bool> init() async {
    if (_preference != null) {
      return true;
    }
    await _storage.ready;
    _storage.clear();
    _streamController.add(this);
    _preference = await SharedPreferences.getInstance();
    _streamController.add(this);

    return isReady;
  }

  Future<void> _setBoolValue(String key, bool value) async {
    if (!isReady) await init();
    _preference!.setBool(key, value);
    _streamController.add(this);
  }

  bool _getBoolValue(String key) => _preference?.getBool(key) ?? false;

  String getOnboardingKey(MainScreen screen) {
    return _onboardingKeys[screen]!;
  }

  bool getOnboardingStatus(MainScreen screen) =>
      _getBoolValue(_onboardingKeys[screen]!);

  Future<void> updateOnboardingStatus(
    MainScreen screen, {
    bool status = true,
  }) =>
      _setBoolValue(_onboardingKeys[screen]!, status);

  List<String> getRecentSearches(String userId) =>
      _preference?.getStringList('$userId/discover/search/recent') ?? [];

  Future<void> setRecentSearches(String userId, List<String> queries) async {
    if (!isReady) await init();
    _preference!.setStringList(
      '$userId/discover/search/recent',
      [...queries],
    );
    _streamController.add(this);
  }

  Future<void> addRecentSearches(String userId, String query) async {
    if (!isReady) await init();

    final recentSearches = getRecentSearches(userId);
    if (recentSearches.contains(query)) {
      recentSearches.remove(query);
    }

    _preference!.setStringList(
      '$userId/discover/search/recent',
      [query, ...recentSearches],
    );
    _streamController.add(this);
  }

  Future<void> setSessionCache(String key, String value) async {
    _storage.setItem(key, value);
  }

  String? getSessionCache(String key) => _storage.getItem(key);
}
