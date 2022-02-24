import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../models/lokal_user.dart';
import '../services/database.dart';

class Users extends ChangeNotifier {
  final _db = Database.instance;

  List<LokalUser> _users = [];
  bool _isLoading = false;
  String? _communityId;

  UnmodifiableListView<LokalUser> get users => UnmodifiableListView(_users);

  Stream<List<LokalUser>>? _userStream;
  Stream<List<LokalUser>>? get stream => _userStream;

  StreamSubscription<List<LokalUser>>? _usersSubscription;
  StreamSubscription<List<LokalUser>>? get subscriptionListener =>
      _usersSubscription;

  bool get isLoading => _isLoading;

  LokalUser? findById(String? id) {
    return _users.firstWhereOrNull((user) => user.id == id);
  }

  void setCommunityId(String? id) {
    if (id == _communityId) return;
    _communityId = id;

    _communityId = id;
    if (_communityId == null) {
      _usersSubscription?.cancel();
      _users.clear();
      if (hasListeners) notifyListeners();
      return;
    }

    if (id != null) {
      _isLoading = true;
      if (hasListeners) notifyListeners();
      _usersSubscription?.cancel();
      _userStream = _db.getCommunityUsers(id).map((event) {
        return event.docs.map((doc) => LokalUser.fromDocument(doc)).toList();
      });
      _usersSubscription = _userStream?.listen(_userChangesListener);
    }
  }

  Future<void> _userChangesListener(List<LokalUser> users) async {
    _users = users;
    _isLoading = false;
    if (hasListeners) notifyListeners();
  }

  @override
  void dispose() {
    _usersSubscription?.cancel();
    super.dispose();
  }

  void clear() {
    _users = [];
    notifyListeners();
  }
}
