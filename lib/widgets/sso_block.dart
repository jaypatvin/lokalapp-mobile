import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants.dart';
import 'sso_button.dart';

class SocialBlock extends StatelessWidget {
  final String? label;
  final double? buttonWidth;

  final Function? fbLogin;
  final Function? appleLogin;
  final Function? googleLogin;

  const SocialBlock(
      {this.label,
      this.buttonWidth,
      this.fbLogin,
      this.appleLogin,
      this.googleLogin});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: buttonWidth! * 0.5),
      child: Column(
        children: [
          Text(
            "Sign in with",
            style: TextStyle(
              fontSize: 18.0.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 10.0.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialButton(
                image: AssetImage(kPngFbLogo),
                onTap: this.fbLogin,
                width: this.buttonWidth,
              ),
              SizedBox(width: 10.0.w),
              SocialButton(
                image: AssetImage(kPngAppleLogo),
                onTap: this.appleLogin,
                width: this.buttonWidth,
              ),
              SizedBox(width: 10.0.w),
              SocialButton(
                image: AssetImage(kPngGoogleLogo),
                onTap: this.googleLogin,
                width: this.buttonWidth,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
