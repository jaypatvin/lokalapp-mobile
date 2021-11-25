import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../models/chat_model.dart';
import '../../providers/shops.dart';
import '../../providers/users.dart';
import '../../state/view_model.dart';

class ChatStreamViewModel extends ViewModel {
  ChatStreamViewModel(this.chatStream);
  final Stream<QuerySnapshot<Map<String, dynamic>>> chatStream;

  String? _searchQuery;
  String? get searchQuery => _searchQuery;

  bool _searchFilterHandler(ChatModel chat) {
    bool isMatch = false;

    for (final id in chat.members) {
      final shop = context.read<Shops>().findById(id);
      if (shop != null) {
        isMatch =
            shop.name!.toLowerCase().contains(_searchQuery!.toLowerCase());
      } else {
        final user = context.read<Users>().findById(id);
        if (user != null) {
          isMatch = user.displayName!
              .toLowerCase()
              .contains(_searchQuery!.toLowerCase());
        }
      }

      if (isMatch) break;
    }

    print('returning $isMatch for search $_searchQuery');
    return isMatch;
  }

  void onSearchQueryChanged(String? value) {
    if (_searchQuery == value) return;
    _searchQuery = value;
    notifyListeners();
  }

  List<ChatModel> getChats(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    final chats = snapshot.data!.docs.map<ChatModel>((doc) {
      return ChatModel.fromMap({'id': doc.id, ...doc.data()});
    }).toList();

    return _searchQuery?.isNotEmpty ?? false
        ? chats.where(_searchFilterHandler).toList()
        : chats;
  }
}
