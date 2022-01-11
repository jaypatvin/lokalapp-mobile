import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/constants/assets.dart';

class SocialBlock extends StatelessWidget {
  final String? label;
  final double? buttonWidth;

  final Function? fbLogin;
  final Function? appleLogin;
  final Function? googleLogin;

  const SocialBlock({
    this.label,
    this.buttonWidth,
    this.fbLogin,
    this.appleLogin,
    this.googleLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: buttonWidth! * 0.5),
      child: Column(
        children: [
          Text(
            'Sign in with',
            style: TextStyle(
              fontSize: 18.0.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 10.0.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialButton(
                image: const AssetImage(kPngFbLogo),
                onTap: fbLogin,
                width: buttonWidth,
              ),
              SizedBox(width: 10.0.w),
              _SocialButton(
                image: const AssetImage(kPngAppleLogo),
                onTap: appleLogin,
                width: buttonWidth,
              ),
              SizedBox(width: 10.0.w),
              _SocialButton(
                image: const AssetImage(kPngGoogleLogo),
                onTap: googleLogin,
                width: buttonWidth,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final ImageProvider? image;
  final Function? onTap;
  final double? width;

  const _SocialButton({this.image, this.onTap, this.width});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.circle,
      clipBehavior: Clip.hardEdge,
      color: Colors.grey[200],
      child: Ink.image(
        image: image!,
        fit: BoxFit.fill,
        height: width,
        width: width,
        child: InkWell(
          onTap: onTap as void Function()?,
        ),
      ),
    );
  }
}
