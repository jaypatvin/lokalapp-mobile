import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lokalapp/screens/profile/profile_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../models/app_navigator.dart';
import '../../routers/app_router.dart';
import '../../screens/bottom_navigation.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/custom_app_bar.dart';

class VerifyConfirmationScreen extends StatelessWidget {
  final bool skippable;
  const VerifyConfirmationScreen({Key? key, this.skippable = true})
      : super(key: key);

  Future<bool> _onWillPop() async {
    if (skippable) {
      AppRouter.rootNavigatorKey.currentState?.push(
        AppNavigator.appPageRoute(
          builder: (_) => const BottomNavigation(),
        ),
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return NestedWillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: kInviteScreenColor,
        appBar: CustomAppBar(
          buildLeading: false,
          backgroundColor: kInviteScreenColor,
          actions: [
            TextButton(
              onPressed: () {
                if (skippable) {
                  Navigator.of(context).maybePop();
                } else {
                  AppRouter.profileNavigatorKey.currentState?.popUntil(
                    ModalRoute.withName(
                      ProfileScreen.routeName,
                    ),
                  );
                }
              },
              child: Text(
                'Done',
                style: TextStyle(
                  color: kTealColor,
                  fontSize: 18.0.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: 120.0.h,
                color: const Color(0xFFFFC700),
              ),
              SizedBox(
                height: 20.0.h,
              ),
              Text(
                'Thank you!',
                style: TextStyle(
                  fontSize: 35.0.sp,
                  color: kNavyColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Goldplay',
                ),
              ),
              SizedBox(
                height: 15.0.h,
              ),
              Text(
                'We will notify you when your account has been verified.',
                style: TextStyle(
                  fontSize: 18.0.sp,
                  color: kNavyColor,
                  fontFamily: 'Goldplay',
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
