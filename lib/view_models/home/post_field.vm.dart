import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../routers/app_router.dart';
import '../../screens/home/draft_post.dart';
import '../../state/view_model.dart';

class PostFieldViewModel extends ViewModel {
  PostFieldViewModel({required this.scrollController, this.height = 75.0});
  final ScrollController scrollController;

  final double height;
  double _postFieldOffset = 0.0;
  double get postFieldOffset => _postFieldOffset;

  double _forwardOffset = 0.0;
  double _reverseOffset = 0.0;

  double _currentForwardOffset = 0.0;
  double _currentReverseOffset = 0.0;

  void init() {
    scrollController.addListener(_scrollListener);
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
      if (scrollController.offset - _forwardOffset >= height) {
        if (postFieldOffset == height) return;
        _postFieldOffset = -height;
      } else {
        _postFieldOffset =
            _currentForwardOffset - (scrollController.offset - _forwardOffset);
      }
      if (_currentReverseOffset == postFieldOffset) return;
      _currentReverseOffset = postFieldOffset;
    }
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      _forwardOffset = scrollController.offset;
      _postFieldOffset =
          (_reverseOffset - scrollController.offset) + _currentReverseOffset;

      if (postFieldOffset >= 0) {
        if (postFieldOffset == 0) return;
        _postFieldOffset = 0;
      }
      if (_currentForwardOffset == postFieldOffset) return;
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
