import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../models/lokal_user.dart';
import '../services/api/api.dart';
import '../services/api/user_api_service.dart';
import '../services/database.dart';

class Users extends ChangeNotifier {
  Users._(this._apiService);

  factory Users(API api) {
    final _apiService = UserAPIService(api);
    return Users._(_apiService);
  }

  final UserAPIService _apiService;
  final _db = Database.instance;

  List<LokalUser> _users = [];
  bool _isLoading = false;
  String? _communityId;

  UnmodifiableListView<LokalUser> get users => UnmodifiableListView(_users);
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _usersSubscription;

  bool get isLoading => _isLoading;

  LokalUser? findById(String? id) {
    return _users.firstWhereOrNull((user) => user.id == id);
  }

  void setCommunityId(String? id) {
    if (id != null) {
      if (id == _communityId) return;
      _communityId = id;
      _usersSubscription?.cancel();
      _usersSubscription =
          _db.getCommunityUsers(id).listen(_userChangesListener);
    }
  }

  void _userChangesListener(QuerySnapshot<Map<String, dynamic>> query) async {
    final length = query.docChanges.length;
    if (_isLoading || length > 1) return;
    for (final change in query.docChanges) {
      final id = change.doc.id;
      final user = await _apiService.getById(userId: id);
      final index = _users.indexWhere((u) => u.id == id);

      if (index >= 0) {
        _users[index] = user;
      } else {
        _users.add(user);
      }

      notifyListeners();
    }
  }

  @override
  void dispose() {
    _usersSubscription?.cancel();
    super.dispose();
  }

  Future<void> fetch() async {
    _isLoading = true;
    notifyListeners();
    try {
      this._users = await _apiService.getCommunityUsers(
        communityId: _communityId!,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  void clear() {
    _users = [];
    notifyListeners();
  }
}
