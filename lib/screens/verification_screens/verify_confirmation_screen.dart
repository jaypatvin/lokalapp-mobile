import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../bottom_navigation.dart';

import '../../utils/themes.dart';

class VerifyConfirmationScreen extends StatefulWidget {
  @override
  _VerifyConfirmationScreenState createState() =>
      _VerifyConfirmationScreenState();
}

class _VerifyConfirmationScreenState extends State<VerifyConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kInviteScreenColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomNavigation()),
                        (route) => false);
                  },
                  child: Text(
                    "Done",
                    style: TextStyle(
                      color: kTealColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "GoldPlay",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Icon(
                Icons.check_circle_outline_rounded,
                size: MediaQuery.of(context).size.height * 0.2,
                color: Color(0xFFFFC700),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(
                "Thank you!",
                style: TextStyle(
                  fontSize: 40.0,
                  color: kNavyColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Goldplay",
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Text(
                "We will notify you when your account has been verified",
                style: TextStyle(
                  fontSize: 24.0,
                  color: kNavyColor,
                  fontFamily: "Goldplay",
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
