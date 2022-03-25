import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';

import '../models/community.dart';
import '../services/database/database.dart';

class CommunityProvider extends ChangeNotifier {
  CommunityProvider(this._db);
  final Database _db;

  String? _communityId;
  String? get communityId => _communityId;

  Community? _community;
  Community? get community => _community;

  Future<void> setCommunityId(String? id) async {
    if (id == _communityId && _community != null) return;
    try {
      _communityId = id;
      if (id != null) {
        _community = await _db.community.getCommunity(id);
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
