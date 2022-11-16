import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/app_navigator.dart';
import '../utils/constants/assets.dart';
import '../utils/constants/themes.dart';
import '../widgets/app_button.dart';
import '../widgets/overlays/constrained_scrollview.dart';
import 'auth/invite_screen.dart';
import 'auth/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/welcome';
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kYellowColor,
      body: SafeArea(
        child: ConstrainedScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 90.0,
                      child: Hero(
                        tag: kSvgLokalLogoV2,
                        child: SvgPicture.asset(
                          kSvgLokalLogoV2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Welcome to Lokal',
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Get to know more your neighborhood safely and securely.',
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Flexible(
                flex: 2,
                child: Column(
                  children: [
                    AppButton.filled(
                      width: 168,
                      text: 'Sign-in',
                      onPressed: () => Navigator.push(
                        context,
                        AppNavigator.appPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      ),
                    ),
                    AppButton.filled(
                      width: 168,
                      text: 'Register',
                      color: kOrangeColor,
                      onPressed: () => Navigator.push(
                        context,
                        AppNavigator.appPageRoute(
                          builder: (_) => const InvitePage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
