import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../utils/constants/assets.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../widgets/app_button.dart';
import '../../../welcome_screen.dart';

class AccountDeleted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kYellowColor,
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Hero(
                  tag: 'home',
                  child: SvgPicture.asset(
                    kSvgLokalLogo,
                    color: kOrangeColor,
                    fit: BoxFit.cover,
                  ),
                ),
                Hero(
                  tag: 'plaza',
                  child: Text(
                    'Your neighborhood plaza',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: kTealColor),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Account Deleted!',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Goldplay',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Text(
            "We're sad to see you go :(\n"
            'If you change your mind, you can\n'
            'log back in again within 30 days!',
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: AppButton(
              'Okay',
              kTealColor,
              true,
              () {
                // FirebaseAuth.instance.signOut();
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => WelcomeScreen(),
                  ),
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
