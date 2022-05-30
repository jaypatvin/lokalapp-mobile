import 'package:flutter/material.dart';
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
      appBar: const CustomAppBar(
        backgroundColor: kTealColor,
        titleText: 'Settings',
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(top: 20),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Account Settings',
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(color: kTealColor),
              ),
            ),
            const SizedBox(height: 10),
            ...ListTile.divideTiles(
              color: const Color(0xFFF2F2F2),
              tiles: [
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontWeight: FontWeight.w400),
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontWeight: FontWeight.w400),
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontWeight: FontWeight.w400),
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontWeight: FontWeight.w400),
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontWeight: FontWeight.w400),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: kTealColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 39),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Support',
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(color: kTealColor),
              ),
            ),
            const SizedBox(height: 10),
            ...ListTile.divideTiles(
              color: const Color(0xFFF2F2F2),
              tiles: [
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontWeight: FontWeight.w400),
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontWeight: FontWeight.w400),
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontWeight: FontWeight.w400),
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontWeight: FontWeight.w400),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: kTealColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: Wrap(
                children: [
                  AppButton.filled(
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
