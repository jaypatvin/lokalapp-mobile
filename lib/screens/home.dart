import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../providers/activities.dart';
import '../utils/constants.dart';
import '../utils/themes.dart';
import '../widgets/custom_app_bar.dart';
import 'cart/cart_container.dart';
import 'home/draft_post.dart';
import 'home/timeline.dart';

class Home extends StatefulWidget {
  static const routeName = "/home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController _controller;
  double _postFieldHeight = 85.0.h;

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
      if (_postFieldHeight != 0)
        setState(() {
          _postFieldHeight = 0;
        });
    }
    if (_controller.position.userScrollDirection == ScrollDirection.forward) {
      if (_postFieldHeight == 0)
        setState(() {
          _postFieldHeight = 85.0.h;
        });
    }
  }

  Widget _postField() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _postFieldHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0.w,
          vertical: 15.h,
        ),
        child: GestureDetector(
          onTap: () => pushNewScreen(
            context,
            screen: DraftPost(),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
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
    return Scaffold(
      backgroundColor: Color(0xffF1FAFF),
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        titleText: "White Plains",
        titleStyle: TextStyle(color: Colors.white),
        backgroundColor: kTealColor,
        buildLeading: false,
      ),
      body: CartContainer(
        child: Column(
          children: [
            _postField(),
            Expanded(
              child: Consumer<Activities>(
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
                          child: Timeline(activities.feed, _controller),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
