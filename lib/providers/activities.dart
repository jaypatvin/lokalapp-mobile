import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/activity_feed.dart';
import '../services/lokal_api_service.dart';

class Activities extends ChangeNotifier {
  String _communityId;
  List<ActivityFeed> _feed = [];
  bool _isLoading;

  bool get isLoading => _isLoading;
  List get feed {
    return [..._feed];
  }

  String get communityId => _communityId;
  //set communityId(String communityId) => this._communityId = communityId;
  //
  void setCommunityId(String id) {
    _communityId = id;
  }

  ActivityFeed findById(String id) {
    return _feed.firstWhere((activity) => activity.id == id);
  }

  List<ActivityFeed> findByUser(String userId) {
    return _feed.where((activity) => activity.userId == userId).toList();
  }

  Future<void> fetch(String authToken) async {
    _isLoading = true;
    try {
      var response = await LokalApiService.instance.activity
          .getCommunityActivities(communityId: communityId, idToken: authToken);

      if (response.statusCode != 200) {
        _isLoading = false;
        return;
      }

      var data = json.decode(response.body);

      if (data['status'] == 'ok') {
        List<ActivityFeed> activities = [];

        for (var activity in data['data']) {
          var _activity = ActivityFeed.fromMap(activity);
          activities.add(_activity);
        }

        _feed = activities..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        notifyListeners();
      }

      _isLoading = false;
    } catch (e) {
      _isLoading = false;
    }
  }

  Future<bool> post(String authToken, Map data) async {
    try {
      var response = await LokalApiService.instance.activity
          .create(idToken: authToken, data: data);

      if (response.statusCode != 200) {
        return false;
      }
      var body = json.decode(response.body);
      if (body['status'] == 'ok') {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
