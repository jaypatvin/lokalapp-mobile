import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lokalapp/screens/invite_page.dart';
import 'package:lokalapp/states/currentUser.dart';

import 'package:lokalapp/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:lokalapp/widgets/social_button.dart';

import 'home.dart';

enum LoginType { email, google, facebook }

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Color _kMainColor = const Color(0xFFFFC700);
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _inputFieldValid = true; // shows or hides the error code

  void _logInUserWithEmail(
      {@required LoginType type,
      String email,
      String password,
      BuildContext context}) async {
    CurrentUser _users = Provider.of<CurrentUser>(context, listen: false);
    try {
      authStatus _authStatus;
      switch (type) {
        case LoginType.email:
          _authStatus = await _users.loginUserWithEmail(email, password);
          break;
        case LoginType.google:
          _authStatus = await _users.loginUserWithGoogle();
          break;
        case LoginType.facebook:
          _authStatus = await _users.loginUserWithFacebook();
          break;
        default:
      }

      if (_authStatus == authStatus.Success) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      } else if (_authStatus == authStatus.PasswordNotValid) {
        setState(() {
          // shows the error code from the TextField
          _inputFieldValid = false;
        });
      } else if (_authStatus == authStatus.UserNotFound) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => InvitePage()),
            (route) => false);
      }
    } catch (e) {
      print(e);
    }
  }

  InputDecoration _kInputDecoration = const InputDecoration(
    filled: true,
    isDense: true,
    enabledBorder: const OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(30.0),
      ),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 25,
      vertical: 10,
    ),
    hintStyle: TextStyle(
      color: Color(0xFFBDBDBD),
      fontFamily: "Goldplay",
      fontWeight: FontWeight.normal,
    ),
    alignLabelWithHint: true,
    border: const OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(
          30.0,
        ),
      ),
    ),
  );

  Widget buildEmail() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        fontFamily: "Goldplay",
        fontWeight: FontWeight.bold,
      ),
      decoration: _kInputDecoration.copyWith(
        hintText: "Email",
        fillColor: Color(0xFFF2F2F2),
      ),
    );
  }

  Widget buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      style: TextStyle(
        fontFamily: "Goldplay",
        fontWeight: FontWeight.bold,
      ),
      decoration: _kInputDecoration.copyWith(
        hintText: "Password",
        fillColor: Color(0xFFF2F2F2),
        errorText: _inputFieldValid
            ? null
            : "The email and password combination is incorrect.",
        errorStyle: TextStyle(
          fontFamily: "Goldplay",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildSocialBlock() {
    return Column(
      children: [
        SocialButton(
          label: "Sign in with Facebook",
          onPressed: () =>
              _logInUserWithEmail(type: LoginType.facebook, context: context),
          minWidth: MediaQuery.of(context).size.width,
        ),
        SocialButton(
          label: "Sign in with Google",
          onPressed: () {
            _logInUserWithEmail(type: LoginType.google, context: context);
          },
          minWidth: MediaQuery.of(context).size.width,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(
                color: _kMainColor,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: "home",
                      child: Image.asset("assets/Lokalv2.png"),
                    ),
                    Hero(
                      tag: "plaza",
                      child: Text(
                        "Your neighborhood plaza",
                        style: TextStyle(
                          color: kTealColor,
                          fontFamily: "Goldplay",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildEmail(),
                        SizedBox(
                          height: 20.0,
                        ),
                        buildPasswordTextField(),
                        SizedBox(
                          height: 30.0,
                        ),
                        RoundedButton(
                          label: "LOG IN",
                          onPressed: () {
                            _logInUserWithEmail(
                                type: LoginType.email,
                                email: _emailController.text,
                                password: _passwordController.text,
                                context: context);
                          },
                        ),
                      ],
                    ),
                    buildSocialBlock(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
