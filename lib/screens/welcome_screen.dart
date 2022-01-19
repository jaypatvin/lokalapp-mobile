import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants/themes.dart';
import '../widgets/app_button.dart';
import 'auth/invite_screen.dart';
import 'auth/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/welcome';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kYellowColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 100.0.h,
                    child: Image.asset(
                      'assets/Lokalv2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 20.0.h),
                  Text(
                    'Welcome to Lokal',
                    style: TextStyle(
                      color: kNavyColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 32.0.sp,
                    ),
                  ),
                  SizedBox(height: 18.0.h),
                  const Text(
                    'Get to know more your neighborhood safely and securely.',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Goldplay',
                      color: kNavyColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5.0.h),
                ],
              ),
              SizedBox(height: 36.0.h),
              SizedBox(
                width: 172.w,
                height: 40.h,
                child: AppButton.filled(
                  text: 'SIGN IN',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0.h),
              SizedBox(
                width: 172.w,
                height: 40.h,
                child: AppButton.filled(
                  text: 'REGISTER',
                  color: kOrangeColor,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InvitePage(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
