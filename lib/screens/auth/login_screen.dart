import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user.dart';
import '../../providers/user_auth.dart';
import '../../utils/themes.dart';
import '../../widgets/rounded_button.dart';
import '../../widgets/sso_block.dart';
import '../bottom_navigation.dart';
import 'invite_page.dart';

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

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Card(
            color: _kMainColor,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: CircularProgressIndicator(),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 25.0),
                      child: Text(
                        "Signing in..",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _logInUser(
      {@required LoginType type, String email, String password}) async {
    CurrentUser user = Provider.of<CurrentUser>(context, listen: false);
    UserAuth auth = Provider.of<UserAuth>(context, listen: false);
    _onLoading();
    try {
      AuthStatus _authStatus;

      switch (type) {
        case LoginType.email:
          _authStatus = await auth.loginWithEmail(email, password);
          break;
        case LoginType.google:
          _authStatus = await auth.loginrWithGoogle();
          break;
        case LoginType.facebook:
          _authStatus = await auth.loginWithFacebook();
          break;
        default:
      }
      if (_authStatus == AuthStatus.Success) {
        await user.fetch(auth.user);
        if (user.state == UserState.LoggedIn) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => BottomNavigation()),
              (route) => false);
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => InvitePage()));
        }
      } else if (_authStatus == AuthStatus.UserNotFound) {
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
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false, // added as above is deprecated
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
                width: double.infinity,
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
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
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
