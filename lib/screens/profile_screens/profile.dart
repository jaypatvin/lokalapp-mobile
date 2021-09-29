import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/models/nested_will_pop_scope.dart';
import 'package:provider/provider.dart';

import '../../providers/activities.dart';
import '../../providers/user.dart';
import '../../utils/constants.dart';
import '../../utils/themes.dart';
import '../home/timeline.dart';
import 'components/my_profile_list.dart';
import 'components/profile_header.dart';
import 'components/user_shop_banner.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "/profile";
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final user = context.read<CurrentUser>();
    return NestedWillPopScope(
      onWillPop: () async {
        if (_pageController.page == 0)
          return true;
        else {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeIn,
          );
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: kInviteScreenColor,
        body: SafeArea(
          child: SizedBox(
            child: Column(
              children: [
                ProfileHeader(),
                UserShopBanner(),
                SizedBox(height: 20.0.h),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.0.w),
                            width: double.infinity,
                            child: Text(
                              "My Profile",
                              style: TextStyle(
                                color: kTealColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          MyProfileList(
                            onMyPostsTap: () => _pageController.animateToPage(
                              1,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeIn,
                            ),
                            onInviteFriend: null,
                            onNotificationsTap: null,
                            onWishlistTap: null,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onPanUpdate: (data) {
                          if (data.delta.dx > 0) {
                            Navigator.maybePop(context);
                          }
                        },
                        child: SingleChildScrollView(
                          child: Container(
                            color: Color(0XFFF1FAFF),
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
                                          child:
                                              Lottie.asset(kAnimationLoading),
                                        ),
                                      )
                                    : RefreshIndicator(
                                        onRefresh: () => activities.fetch(),
                                        child: Timeline(
                                          activities.findByUser(user.id),
                                        ),
                                      );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
