import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../models/app_navigator.dart';
import '../../routers/app_router.dart';
import '../../screens/bottom_navigation.dart';
import '../../screens/profile/profile_screen.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/custom_app_bar.dart';

class VerifyConfirmationScreen extends StatelessWidget {
  final bool skippable;
  const VerifyConfirmationScreen({super.key, this.skippable = true});

  Future<bool> _onWillPop() async {
    if (skippable) {
      AppRouter.rootNavigatorKey.currentState?.push(
        AppNavigator.appPageRoute(
          builder: (_) => const BottomNavigation(),
        ),
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return NestedWillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: kInviteScreenColor,
        appBar: CustomAppBar(
          buildLeading: false,
          backgroundColor: kInviteScreenColor,
          actions: [
            TextButton(
              onPressed: () {
                if (skippable) {
                  Navigator.of(context).maybePop();
                } else {
                  AppRouter.profileNavigatorKey.currentState?.popUntil(
                    ModalRoute.withName(
                      ProfileScreen.routeName,
                    ),
                  );
                }
              },
              child: Text(
                'Done',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: kTealColor),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 37),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                size: 100,
                color: Color(0xFFFFC700),
              ),
              const SizedBox(height: 30),
              Text(
                'Thank you!',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 10),
              Text(
                'We will notify you when your account has been verified.',
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
