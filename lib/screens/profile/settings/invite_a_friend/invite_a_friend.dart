import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/constants/themes.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/inputs/input_email_field.dart';
import '../../../../widgets/inputs/input_field.dart';

class InviteAFriend extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1FAFF),
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        titleText: 'Invite a Friend',
        backgroundColor: kTealColor,
        titleStyle: TextStyle(
          color: Colors.white,
        ),
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.w),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          "Expand your community!",
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    color: kTealColor,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 36.0.w),
                    child: Text(
                      "Share an invite code by entering the recipient's email "
                      "address below.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20.0.h),
                  InputEmailField(
                    validate: true,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0.h),
                    child: Text('or'),
                  ),
                  InputField(
                    fillColor: Colors.white,
                    hintText: 'Phone Number',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20.0.h),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: AppButton(
                      'SEND INVITE CODE',
                      kTealColor,
                      true,
                      () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Not yet implemented.'),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
