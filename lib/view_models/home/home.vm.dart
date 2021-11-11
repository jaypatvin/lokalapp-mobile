import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../routers/app_router.dart';
import '../../screens/home/draft_post.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this.context, {this.postFieldHeight = 75.0});

  final BuildContext context;
  late final ScrollController scrollController;

  final double postFieldHeight;
  double postFieldOffset = 0.0;

  double _forwardOffset = 0.0;
  double _reverseOffset = 0.0;

  double _currentForwardOffset = 0.0;
  double _currentReverseOffset = 0.0;

  void init() {
    scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      _reverseOffset = scrollController.offset;
      if (scrollController.offset - _forwardOffset >= postFieldHeight) {
        if (postFieldOffset == postFieldHeight) return;
        postFieldOffset = -postFieldHeight;
      } else {
        postFieldOffset =
            _currentForwardOffset - (scrollController.offset - _forwardOffset);
      }
      _currentReverseOffset = postFieldOffset;
    }
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      _forwardOffset = scrollController.offset;
      postFieldOffset =
          (_reverseOffset - scrollController.offset) + _currentReverseOffset;

      if (postFieldOffset >= 0) {
        if (postFieldOffset == 0) return;
        postFieldOffset = 0;
      }

      _currentForwardOffset = postFieldOffset;
    }

    notifyListeners();
  }

  void onDraftPostTapHandler() {
    context
        .read<AppRouter>()
        .keyOf(AppRoute.root)
        .currentState!
        .pushNamed(DraftPost.routeName);
  }
}
