import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/widgets/custom_app_bar.dart';
import '../bottom_navigation.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/themes.dart';

class VerifyConfirmationScreen extends StatefulWidget {
  @override
  _VerifyConfirmationScreenState createState() =>
      _VerifyConfirmationScreenState();
}

class _VerifyConfirmationScreenState extends State<VerifyConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kInviteScreenColor,
      appBar: CustomAppBar(
        buildLeading: false,
        backgroundColor: kInviteScreenColor,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => BottomNavigation()),
                (route) => false,
              );
            },
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
    );
  }
}
