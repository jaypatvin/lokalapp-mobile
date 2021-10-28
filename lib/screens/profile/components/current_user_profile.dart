import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/models/nested_will_pop_scope.dart';
import 'package:provider/provider.dart';

import '../../../providers/activities.dart';
import '../../../providers/auth.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/profile/components/current_user_profile.vm.dart';
import '../../home/timeline.dart';
import 'my_profile_list.dart';

class CurrentUserProfile extends StatelessWidget {
  const CurrentUserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => CurrentUserProfileViewModel(ctx),
      builder: (ctx, _) {
        return Consumer<CurrentUserProfileViewModel>(
          builder: (ctx2, vm, _) {
            final user = ctx2.read<Auth>().user!;
            return NestedWillPopScope(
              onWillPop: vm.onWillPop,
              child: PageView(
                controller: vm.pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Column(
                    children: [
                      Container(
                        color: kInviteScreenColor,
                        padding: EdgeInsets.fromLTRB(
                          10.0.w,
                          20.0.w,
                          10.0.w,
                          10.0.w,
                        ),
                        width: double.infinity,
                        child: Text(
                          "My Profile",
                          style: TextStyle(
                            color: kTealColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: MyProfileList(
                          onMyPostsTap: vm.onMyPostsTap,
                          onInviteFriend: vm.onInviteFriend,
                          onNotificationsTap: vm.onNotificationsTap,
                          onWishlistTap: vm.onWishlistTap,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onPanUpdate: vm.onPanUpdate,
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
                                      child: Lottie.asset(kAnimationLoading),
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: () => activities.fetch(),
                                    child: Timeline(
                                      activities.findByUser(user.id),
                                      null,
                                    ),
                                  );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
