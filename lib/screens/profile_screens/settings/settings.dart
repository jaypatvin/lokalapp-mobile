import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../welcome_screen.dart';
import '../components/invite_a_friend.dart';
import 'chat/chat_settings.dart';
import 'email/my_account.dart';
import 'help%20center/help_center.dart';
import 'notification%20settings/notification_setting.dart';
import 'privacy%20setting/privacy_setting.dart';
import 'terms%20of%20service/terms_of_service.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1FAFF),
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        backgroundColor: kTealColor,
        titleText: "Settings",
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
                padding: const EdgeInsets.only(
                  left: 15,
                  top: 30,
                ),
                child: Text(
                  "Account Settings",
                  style: TextStyle(
                      fontFamily: "GoldplayBold",
                      fontWeight: FontWeight.w300,
                      color: kTealColor),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                leading: Text(
                  "My Account",
                  style: TextStyle(fontFamily: "GoldplayBold"),
                ),
                trailing: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyAccount()));
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: kTealColor,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatSettings()));
              },
              child: Container(
                color: Colors.white,
                child: ListTile(
                  leading: Text(
                    "Chat Settings",
                    style: TextStyle(fontFamily: "GoldplayBold"),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: kTealColor,
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                leading: Text(
                  "Notification Settings",
                  style: TextStyle(fontFamily: "GoldplayBold"),
                ),
                trailing: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationSetting()));
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: kTealColor,
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                leading: Text(
                  "Privacy Settings",
                  style: TextStyle(fontFamily: "GoldplayBold"),
                ),
                trailing: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PrivacySetting()));
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: kTealColor,
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                leading: Text(
                  "Invite a friend",
                  style: TextStyle(fontFamily: "GoldplayBold"),
                ),
                trailing: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InviteAFriend()));
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: kTealColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                padding: const EdgeInsets.only(
                  left: 15,
                  top: 30,
                ),
                child: Text(
                  "Support",
                  style: TextStyle(
                      fontFamily: "GoldplayBold",
                      fontWeight: FontWeight.w300,
                      color: kTealColor),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                leading: Text(
                  "Help Center",
                  style: TextStyle(fontFamily: "GoldplayBold"),
                ),
                trailing: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HelpCenter()));
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: kTealColor,
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                leading: Text(
                  "Contact Us",
                  style: TextStyle(fontFamily: "GoldplayBold"),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: kTealColor,
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                leading: Text(
                  "Terms of Service",
                  style: TextStyle(fontFamily: "GoldplayBold"),
                ),
                trailing: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TermsOfService()));
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: kTealColor,
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                leading: Text(
                  "Privacy Policy",
                  style: TextStyle(fontFamily: "GoldplayBold"),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: kTealColor,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AppButton(
                "Log Out",
                kPinkColor,
                true,
                () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => WelcomeScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
