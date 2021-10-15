import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/models/nested_will_pop_scope.dart';

import '../../utils/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../bottom_navigation.dart';

class VerifyConfirmationScreen extends StatelessWidget {
  final bool skippable;
  const VerifyConfirmationScreen({Key? key, this.skippable = true})
      : super(key: key);

  Future<bool> _onWillPop(BuildContext context) async {
    if (this.skippable) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigation()),
        (route) => false,
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return NestedWillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: kInviteScreenColor,
        appBar: CustomAppBar(
          buildLeading: false,
          backgroundColor: kInviteScreenColor,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).maybePop<bool>(true),
              child: Text(
                "Done",
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
                color: Color(0xFFFFC700),
              ),
              SizedBox(
                height: 20.0.h,
              ),
              Text(
                "Thank you!",
                style: TextStyle(
                  fontSize: 35.0.sp,
                  color: kNavyColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Goldplay",
                ),
              ),
              SizedBox(
                height: 15.0.h,
              ),
              Text(
                "We will notify you when your account has been verified.",
                style: TextStyle(
                  fontSize: 18.0.sp,
                  color: kNavyColor,
                  fontFamily: "Goldplay",
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
