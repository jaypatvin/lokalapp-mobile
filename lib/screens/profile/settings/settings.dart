import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../welcome_screen.dart';
import 'invite_a_friend/invite_a_friend.dart';
import 'chat/chat_settings.dart';
import 'my_account/my_account.dart';
import 'help_center/help_center.dart';
import 'notification_settings/notification_setting.dart';
import 'privacy_settings/privacy_setting.dart';
import 'terms_of_service/terms_of_service.dart';

class Settings extends StatelessWidget {
  static const routeName = '/profile/settings';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1FAFF),
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        backgroundColor: kTealColor,
        titleText: 'Settings',
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
              onTap: () => pushNewScreen(context, screen: MyAccount()),
              tileColor: Colors.white,
              leading: Text(
                "My Account",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: kTealColor,
              ),
            ),
            ListTile(
              onTap: () => pushNewScreen(context, screen: ChatSettings()),
              tileColor: Colors.white,
              leading: Text(
                "Chat Settings",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: kTealColor,
              ),
            ),
            ListTile(
              onTap: () =>
                  pushNewScreen(context, screen: NotificationSetting()),
              tileColor: Colors.white,
              leading: Text(
                "Notification Settings",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: kTealColor,
              ),
            ),
            ListTile(
              onTap: () => pushNewScreen(context, screen: PrivacySetting()),
              tileColor: Colors.white,
              leading: Text(
                "Privacy Settings",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: kTealColor,
              ),
            ),
            ListTile(
              onTap: () => pushNewScreen(context, screen: InviteAFriend()),
              tileColor: Colors.white,
              leading: Text(
                "Invite a friend",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: Icon(
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
              onTap: () => pushNewScreen(context, screen: HelpCenter()),
              tileColor: Colors.white,
              leading: Text(
                "Help Center",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: kTealColor,
              ),
            ),
            ListTile(
              onTap: null,
              enabled: false,
              tileColor: Colors.white,
              leading: Text(
                "Contact Us",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: kTealColor,
              ),
            ),
            ListTile(
              onTap: () => pushNewScreen(context, screen: TermsOfService()),
              tileColor: Colors.white,
              leading: Text(
                "Terms of Service",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: kTealColor,
              ),
            ),
            ListTile(
              tileColor: Colors.white,
              enabled: false,
              leading: Text(
                "Privacy Policy",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: Icon(
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
                    child: AppButton(
                      "Log Out",
                      kPinkColor,
                      true,
                      () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context, rootNavigator: true)
                            .pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => WelcomeScreen(),
                          ),
                          (route) => false,
                        );
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
