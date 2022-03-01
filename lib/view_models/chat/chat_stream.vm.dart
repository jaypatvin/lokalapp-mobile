import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../models/chat_model.dart';
import '../../providers/shops.dart';
import '../../providers/users.dart';
import '../../routers/app_router.dart';
import '../../state/view_model.dart';

class ChatStreamViewModel extends ViewModel {
  ChatStreamViewModel(this.chatStream);
  final Stream<List<ChatModel>>? chatStream;

  String? _searchQuery;
  String? get searchQuery => _searchQuery;

  bool _searchFilterHandler(ChatModel chat) {
    bool isMatch = false;

    for (final id in chat.members) {
      final shop = context.read<Shops>().findById(id);
      if (shop != null) {
        isMatch = shop.name.toLowerCase().contains(_searchQuery!.toLowerCase());
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

    debugPrint('returning $isMatch for search $_searchQuery');
    return isMatch;
  }

  void onSearchQueryChanged(String? value) {
    if (_searchQuery == value) return;
    _searchQuery = value;
    notifyListeners();
  }

  List<ChatModel> getChats(
    AsyncSnapshot<List<ChatModel>> snapshot,
  ) {
    return _searchQuery?.isNotEmpty ?? false
        ? snapshot.data!.where(_searchFilterHandler).toList()
        : snapshot.data!;
  }

  void createShopHandler() {
    context.read<AppRouter>().jumpToTab(AppRoute.profile);
  }
}
