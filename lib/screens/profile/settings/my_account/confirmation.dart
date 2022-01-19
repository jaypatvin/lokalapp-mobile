import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../routers/app_router.dart';
import '../../../../utils/constants/assets.dart';
import '../../../../widgets/app_button.dart';
import '../settings.dart';

class MyAccountConfirmation extends StatelessWidget {
  const MyAccountConfirmation({this.isPassword = false});
  final bool isPassword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                isPassword ? 'Password Changed!' : 'Email Address Changed!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Lottie.asset(
              kAnimationConfirmation,
              fit: BoxFit.contain,
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              width: double.infinity,
              child: AppButton.filled(
                text: 'Back to Settings',
                onPressed: () =>
                    AppRouter.profileNavigatorKey.currentState?.popUntil(
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
