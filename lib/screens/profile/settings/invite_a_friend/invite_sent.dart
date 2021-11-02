import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lokalapp/widgets/app_button.dart';
import 'package:lottie/lottie.dart';

import '../../../../utils/constants/assets.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../widgets/custom_app_bar.dart';

class InviteSent extends StatelessWidget {
  buildButtons(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 43,
          width: 180,
          child: FlatButton(
            // height: 50,
            // minWidth: 100,
            color: kTealColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(color: kTealColor),
            ),
            textColor: Colors.black,
            child: Text(
              "COPY INVITE CODE",
              style: TextStyle(
                  fontFamily: "Goldplay",
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFF1FAFF),
      appBar: CustomAppBar(
        buildLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          Center(
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  'Done',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: kTealColor,
                      ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 48.0.w),
        child: Column(
          children: [
            Lottie.asset(kAnimationOk, fit: BoxFit.cover),
            SizedBox(height: 15.h),
            Container(
              child: Text(
                'Invite Sent!',
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: kTealColor,
                    ),
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              'Your friend should receive this invite code within a '
              'few minutes.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),
            Text('The invite code is:'),
            Text(
              'AF2 5DH',
              style: Theme.of(context).textTheme.headline2,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0.w),
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  'COPY INVITE CODE',
                  kTealColor,
                  true,
                  () => {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
