import 'package:flutter/material.dart';
import 'package:lokalapp/root/root.dart';
import 'package:lokalapp/screens/profile_screens/settings/chat/chat_settings.dart';
import 'package:lokalapp/screens/profile_screens/settings/email/my_account.dart';
import 'package:lokalapp/screens/profile_screens/settings/help%20center/help_center.dart';
import 'package:lokalapp/screens/profile_screens/settings/notification%20settings/notification_setting.dart';
import 'package:lokalapp/screens/profile_screens/settings/privacy%20setting/privacy_setting.dart';
import 'package:lokalapp/screens/profile_screens/settings/terms%20of%20service/terms_of_service.dart';
import 'package:lokalapp/services/firebase_auth_service.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:provider/provider.dart';

import '../components/invite_a_friend.dart';
import 'about/about.dart';

class Settings extends StatelessWidget {
  buildButton(context) {
    Container(
      padding: const EdgeInsets.only(left: 80, top: 0, right: 80, bottom: 0),
      child: FlatButton(
          color: Color(0XFFCC3752),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Color(0XFFCC3752)),
          ),
          textColor: Colors.black,
          child: Text(
            "LOG OUT",
            style: TextStyle(
                fontFamily: "Goldplay",
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            var user = Provider.of<FirebaseAuthService>(context, listen: false);
            user.signOut();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Root()));
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1FAFF),
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
            ],
          ),
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Container(
            decoration: BoxDecoration(color: kTealColor),
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_sharp,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      "Settings",
                      style: TextStyle(
                          fontFamily: "Goldplay",
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0XFFFFC700)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
            Container(
              color: Colors.white,
              child: ListTile(
                leading: Text(
                  "About",
                  style: TextStyle(fontFamily: "GoldplayBold"),
                ),
                trailing: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => About()));
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
              height: 30,
            ),
            Container(
              padding:
                  const EdgeInsets.only(left: 80, top: 0, right: 80, bottom: 0),
              child: FlatButton(
                  color: Color(0XFFCC3752),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Color(0XFFCC3752)),
                  ),
                  textColor: Colors.black,
                  child: Text(
                    "LOG OUT",
                    style: TextStyle(
                        fontFamily: "Goldplay",
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    // this._authService = Provider.of<FirebaseAuthService>(
                    //     context,
                    //     listen: false);
                    // _authService.signOut();
                    FirebaseAuthService().signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Root()),
                        (route) => false);
                  }),
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
