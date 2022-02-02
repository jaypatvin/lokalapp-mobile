import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';

import '../models/community.dart';
import '../services/api/api.dart';
import '../services/api/community_api_service.dart';

class CommunityProvider extends ChangeNotifier {
  factory CommunityProvider(API api) {
    final apiService = CommunityAPIService(api);
    return CommunityProvider._(apiService);
  }

  CommunityProvider._(this._apiService);

  final CommunityAPIService _apiService;

  String? _communityId;
  String? get communityId => _communityId;

  Community? _community;
  Community? get community => _community;

  Future<void> setCommunityId(String? id) async {
    if (id == _communityId && _community != null) return;
    try {
      _communityId = id;
      if (id != null) {
        _community = await _apiService.getById(id);
      } else {
        _community = null;
      }
      notifyListeners();
    } catch (e, stack) {
      showToast('Community error: $e');

      // We're not rethrowing the error so let's log it here. This lives
      // at the top of the app so there's nothing to catch the error with.
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }
}
