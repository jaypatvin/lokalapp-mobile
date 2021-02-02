import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../screens/bottom_navigation.dart';
import 'invite_page.dart';
import '../widgets/rounded_button.dart';
import '../widgets/sso_block.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../utils/themes.dart';
import '../states/current_user.dart';

enum LoginType { email, google, facebook }

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Color _kMainColor = const Color(0xFFFFC700);
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isAuth = false;
  final _formKey = GlobalKey<FormState>();
  Map<String, String> account;

  void _logInUser(
      {@required LoginType type, String email, String password}) async {
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
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigation()),
            (route) => false);
      } else if (_authStatus == authStatus.UserNotFound) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => InvitePage()));
      }
    } catch (e) {
      // TODO: do something with error
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
    return Form(
      key: _formKey,
      child: TextField(
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
      ),
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
                          onPressed: () async {
                            _logInUser(
                              type: LoginType.email,
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                          },
                        ),
                      ],
                    ),
                    //buildSocialBlock(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                    SocialBlock(
                      fbLogin: () => _logInUser(type: LoginType.facebook),
                      googleLogin: () => _logInUser(type: LoginType.google),
                      buttonWidth: MediaQuery.of(context).size.width * 0.15,
                    )
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
