import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../models/app_navigator.dart';
import '../../../providers/auth.dart';
import '../../../providers/cart.dart';
import '../../../routers/app_router.dart';
import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../welcome_screen.dart';
import 'about/about.dart';
import 'chat/chat_settings.dart';
import 'help_center/help_center.dart';
import 'invite_a_friend/invite_a_friend.dart';
import 'my_account/my_account.dart';
import 'notification_settings/notification_setting.dart';
import 'privacy_policy.dart/privacy_policy.dart';
import 'privacy_settings/privacy_setting.dart';
import 'terms_of_service/terms_of_service.dart';

class Settings extends StatelessWidget {
  static const routeName = '/profile/settings';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1FAFF),
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        backgroundColor: kTealColor,
        titleText: 'Settings',
        titleStyle: const TextStyle(color: Colors.white),
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0.h,
                horizontal: 10.0.w,
              ),
              child: Text(
                'Account Settings',
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: kTealColor,
                    ),
              ),
            ),
            ListTile(
              onTap: () => Navigator.push(
                context,
                AppNavigator.appPageRoute(
                  builder: (_) => const MyAccount(),
                ),
              ),
              tileColor: Colors.white,
              leading: Text(
                'My Account',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: kTealColor,
              ),
            ),
            ListTile(
              onTap: () => Navigator.push(
                context,
                AppNavigator.appPageRoute(
                  builder: (_) => const ChatSettings(),
                ),
              ),
              tileColor: Colors.white,
              leading: Text(
                'Chat Settings',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: kTealColor,
              ),
            ),
            ListTile(
              onTap: () => Navigator.push(
                context,
                AppNavigator.appPageRoute(
                  builder: (_) => const NotificationSettingsScreen(),
                ),
              ),
              tileColor: Colors.white,
              leading: Text(
                'Notification Settings',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: kTealColor,
              ),
            ),
            ListTile(
              onTap: () => Navigator.push(
                context,
                AppNavigator.appPageRoute(
                  builder: (_) => const PrivacySettings(),
                ),
              ),
              tileColor: Colors.white,
              leading: Text(
                'Privacy Settings',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: kTealColor,
              ),
            ),
            ListTile(
              onTap: () => Navigator.push(
                context,
                AppNavigator.appPageRoute(
                  builder: (_) => const InviteAFriend(),
                ),
              ),
              tileColor: Colors.white,
              leading: Text(
                'Invite a friend',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: kTealColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0.h,
                horizontal: 10.0.w,
              ),
              child: Text(
                'Support',
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: kTealColor,
                    ),
              ),
            ),
            ListTile(
              onTap: () => Navigator.push(
                context,
                AppNavigator.appPageRoute(
                  builder: (_) => const HelpCenter(),
                ),
              ),
              tileColor: Colors.white,
              leading: Text(
                'Help Center',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: kTealColor,
              ),
            ),
            ListTile(
              onTap: () => Navigator.push(
                context,
                AppNavigator.appPageRoute(
                  builder: (_) => const TermsOfService(),
                ),
              ),
              tileColor: Colors.white,
              leading: Text(
                'Terms of Service',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: kTealColor,
              ),
            ),
            ListTile(
              onTap: () => Navigator.push(
                context,
                AppNavigator.appPageRoute(
                  builder: (_) => const PrivacyPolicy(),
                ),
              ),
              tileColor: Colors.white,
              leading: Text(
                'Privacy Policy',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: kTealColor,
              ),
            ),
            ListTile(
              onTap: () => Navigator.push(
                context,
                AppNavigator.appPageRoute(
                  builder: (_) => const About(),
                ),
              ),
              tileColor: Colors.white,
              leading: Text(
                'About',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: kTealColor,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Wrap(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: AppButton.filled(
                      text: 'Log Out',
                      color: kPinkColor,
                      onPressed: () async {
                        final _auth = context.read<Auth>();
                        context.read<ShoppingCart>().clear();
                        context.read<AppRouter>()
                          ..jumpToTab(AppRoute.home)
                          ..keyOf(AppRoute.root)
                              .currentState!
                              .pushNamedAndRemoveUntil(
                                WelcomeScreen.routeName,
                                (route) => false,
                              );

                        Future.delayed(const Duration(milliseconds: 500), () {
                          _auth.logOut();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
