import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/activities.dart';
import '../../routers/routers.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../utils/shared_preference.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/overlays/onboarding.dart';
import '../cart/cart_container.dart';
import 'draft_post.dart';
import 'notifications.dart';
import 'timeline.dart';

class Home extends StatefulWidget {
  static const routeName = "/home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final ScrollController _controller;

  double _postFieldHeight = 75.0.h;
  double _offset = 0.0;

  double _forwardOffset = 0.0;
  double _reverseOffset = 0.0;

  double _currentForwardOffset = 0.0;
  double _currentReverseOffset = 0.0;

  @override
  void initState() {
    super.initState();
    final activities = context.read<Activities>();
    if (activities.feed.length == 0) {
      activities.fetch();
    }

    _controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
      _reverseOffset = _controller.offset;
      if (_controller.offset - _forwardOffset >= _postFieldHeight) {
        if (_offset == _postFieldHeight) return;
        _offset = -_postFieldHeight;
      } else {
        _offset = _currentForwardOffset - (_controller.offset - _forwardOffset);
      }
      _currentReverseOffset = _offset;
    }
    if (_controller.position.userScrollDirection == ScrollDirection.forward) {
      _forwardOffset = _controller.offset;
      _offset = (_reverseOffset - _controller.offset) + _currentReverseOffset;

      if (_offset >= 0) {
        if (_offset == 0) return;
        _offset = 0;
      }

      _currentForwardOffset = _offset;
    }
    setState(() {});
  }

  Widget _postField() {
    return Container(
      height: _postFieldHeight,
      width: double.infinity,
      color: kInviteScreenColor.withOpacity(0.7),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0.w,
          vertical: 15.h,
        ),
        child: GestureDetector(
          onTap: () => AppRouter.rootNavigatorKey.currentState!.pushNamed(
            DraftPost.routeName,
          ),
          child: Container(
            height: 50.0.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15.0.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.all(Radius.circular(15.0.r)),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "What's on your mind?",
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  MdiIcons.squareEditOutline,
                  color: Color(0xffE0E0E0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Onboarding(
      screen: MainScreen.home,
      child: Scaffold(
        backgroundColor: Color(0xffF1FAFF),
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          titleText: "White Plains",
          titleStyle: TextStyle(color: Colors.white),
          backgroundColor: kTealColor,
          buildLeading: false,
          actions: [
            IconButton(
              onPressed: () => AppRouter.homeNavigatorKey.currentState!
                  .pushNamed(Notifications.routeName),
              icon: Icon(Icons.notifications_outlined),
            )
          ],
        ),
        body: CartContainer(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Consumer<Activities>(
                  builder: (context, activities, child) {
                    return activities.isLoading
                        ? SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: DecoratedBox(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Lottie.asset(kAnimationLoading),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () => activities.fetch(),
                            child: Timeline(
                              activities.feed,
                              _controller,
                              firstIndexPadding: _postFieldHeight,
                            ),
                          );
                  },
                ),
                Transform.translate(
                  offset: Offset(0, _offset),
                  child: _postField(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
