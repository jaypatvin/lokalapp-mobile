import 'package:flutter/material.dart';
import 'package:lokalapp/utils/themes.dart';

import 'invite_a_friend.dart';

class Settings extends StatelessWidget {
  Widget get buildButton => Container(
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
            onPressed: () {}),
      );
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
      body: ListView(
        // shrinkWrap: true,
        children: [
          Container(
              padding: const EdgeInsets.only(
                left: 15,
                top: 30,
              ),
              child: Text(
                "Account Settings",
                style: TextStyle(
                    fontFamily: "GoldplayBold", fontWeight: FontWeight.w200),
              )),
          SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: Text(
                "My Profile",
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
          Container(
            color: Colors.white,
            child: ListTile(
              leading: Text(
                "Notification Settings",
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
                "Privacy Settings",
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
                "Invite a friend",
                style: TextStyle(fontFamily: "GoldplayBold"),
              ),
              trailing: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => InviteAFriend()));
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
                    fontFamily: "GoldplayBold", fontWeight: FontWeight.w200),
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
          buildButton,
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
