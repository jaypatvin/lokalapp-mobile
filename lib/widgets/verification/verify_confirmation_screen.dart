import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/app_router.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/custom_app_bar.dart';

class VerifyConfirmationScreen extends StatelessWidget {
  final bool skippable;
  const VerifyConfirmationScreen({Key? key, this.skippable = true})
      : super(key: key);

  Future<bool> _onWillPop() async {
    if (skippable) {
      locator<AppRouter>().navigateTo(AppRoute.root, Routes.dashboard);
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
                  locator<AppRouter>().popUntil(
                    AppRoute.profile,
                    predicate: ModalRoute.withName(
                      DashboardRoutes.profileScreen,
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
