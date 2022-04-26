import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../../../app/app.locator.dart';
import '../../../../app/app.router.dart';
import '../../../../app/app_router.dart';
import '../../../../utils/constants/assets.dart';
import '../../../../widgets/app_button.dart';

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
            const Spacer(),
            Text(
              isPassword ? 'Password Changed!' : 'Email Address Changed!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.black,
                  ),
            ),
            Stack(
              children: [
                Positioned.fill(
                  child: SvgPicture.asset(kSvgBackgroundHouses),
                ),
                Center(
                  child: Lottie.asset(
                    kAnimationConfirmation,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              width: double.infinity,
              child: AppButton.filled(
                text: 'Back to Settings',
                onPressed: () => locator<AppRouter>().popUntil(
                  AppRoute.profile,
                  predicate: ModalRoute.withName(ProfileScreenRoutes.settings),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
