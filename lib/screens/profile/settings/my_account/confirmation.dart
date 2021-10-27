import 'package:flutter/material.dart';
import 'package:lokalapp/utils/constants/assets.dart';
import 'package:lokalapp/widgets/app_button.dart';
import 'package:lottie/lottie.dart';
import '../settings.dart';
import '../../../../utils/constants/themes.dart';

class MyAccountConfirmation extends StatelessWidget {
  const MyAccountConfirmation({this.isPassword = false});
  final bool isPassword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              this.isPassword ? 'Password Changed!' : 'Email Address Changed!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 20),
            Lottie.asset(
              kAnimationConfirmation,
              fit: BoxFit.contain,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AppButton(
                'Back to Settings',
                kTealColor,
                true,
                () => Navigator.popUntil(
                  context,
                  ModalRoute.withName(Settings.routeName),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
