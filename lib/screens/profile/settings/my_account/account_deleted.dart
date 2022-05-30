import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../models/app_navigator.dart';
import '../../../../utils/constants/assets.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/overlays/constrained_scrollview.dart';
import '../../../welcome_screen.dart';

class AccountDeleted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kYellowColor,
      body: ConstrainedScrollView(
        child: Column(
          children: [
            const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'home',
                    child: SvgPicture.asset(
                      kSvgLokalLogo,
                      color: kOrangeColor,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Hero(
                    tag: 'plaza',
                    child: Text(
                      'Your neighborhood plaza',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: kTealColor,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 64),
            Text(
              'Account Deleted!',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 12),
            Text(
              "We're sad to see you go :(\n"
              'If you change your mind, you can\n'
              'log back in again within 30 days!',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: Colors.black),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: AppButton.filled(
                text: 'Okay',
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    AppNavigator.appPageRoute(
                      builder: (_) => const WelcomeScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
