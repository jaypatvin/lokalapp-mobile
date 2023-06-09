import 'package:flutter/material.dart';
import 'package:lokalapp/utils/shared_preference.dart';
import 'package:provider/provider.dart';

import '../../providers/user.dart';
import '../../providers/user_auth.dart';
import '../../widgets/sso_block.dart';
import '../bottom_navigation.dart';
import 'profile_registration.dart';

enum LoginType { email, google, facebook }

class Community extends StatefulWidget {
  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  Color _kPrimaryColor = Color(0XFFFFC700);
  Color _kButtonColor = Color(0XFF09A49A);
  Color _kButtonFontColor = Color(0XFF103045);
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _signUpUser(
      {@required LoginType type, String email, String password}) async {
    //CurrentUser _user = Provider.of<CurrentUser>(context, listen: false);
    UserAuth auth = Provider.of<UserAuth>(context, listen: false);
    try {
      AuthStatus _authStatus;

      switch (type) {
        case LoginType.email:
          _authStatus = await auth.signUp(email, password);
          break;
        case LoginType.google:
          _authStatus = await auth.loginrWithGoogle();
          break;
        case LoginType.facebook:
          _authStatus = await auth.loginWithFacebook();
          break;
        default:
      }
      if (_authStatus == AuthStatus.NewUser) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProfileRegistration()));
      } else if (_authStatus == AuthStatus.Success) {
        var user = Provider.of<CurrentUser>(context, listen: false);
        await user.fetch(auth.user);
        if (user.state == UserState.LoggedIn) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => BottomNavigation()),
              (route) => false);
        } else if (user.state == UserState.NotRegistered) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProfileRegistration()));
        }
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => PersistentBottomNavBar()),
        //     (route) => false);
      }
    } catch (e) {
      // TODO: do something with error
      print(e);
    }
  }

  Widget buildEmail() {
    return Material(
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(40.0),
                      ),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    hintText: "Email",
                    contentPadding: EdgeInsets.all(18.0)),
              )),
        ],
      ),
    );
  }

  Widget buildPassword() {
    return Material(
      child: Column(
        children: [
          Padding(
              padding:
                  const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
              child: TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(40.0),
                      ),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    hintText: "Password",
                    contentPadding: EdgeInsets.all(18.0)),
              )),
        ],
      ),
    );
  }

  Widget register() {
    return ButtonTheme(
      minWidth: 70,
      height: 55,
      child: Padding(
        padding: EdgeInsets.only(left: 102.0, right: 102.0, top: 50.0),
        child: RaisedButton(
          textColor: _kButtonFontColor,
          color: _kButtonColor,
          child: Text(
            "REGISTER",
            style: TextStyle(
                fontSize: 20.0,
                fontFamily: "GoldplayBoldIt",
                fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            _signUpUser(
                type: LoginType.email,
                email: _emailController.text.trim(),
                password: _passwordController.text.trim());
          },
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(40.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  color: _kPrimaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: "Welcome",
                        child: Center(
                          child: Text(
                            "Welcome to",
                            style: TextStyle(
                                fontFamily: "Goldplay.otf", fontSize: 28.0),
                          ),
                        ),
                      ),
                      Hero(
                        tag: "Community",
                        child: Center(
                          child: Text(
                            "Community Name",
                            style: TextStyle(
                                fontFamily: "GoldplayAltBoldIt.otf",
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100.0,
                      ),
                      Center(
                        child: Text(
                          "Create an account below",
                          style: TextStyle(
                              fontFamily: "GoldplayBold",
                              // fontWeight: FontWeight.w500,
                              fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                ),
                buildEmail(),
                buildPassword(),
                register(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                SocialBlock(
                  fbLogin: () => _signUpUser(type: LoginType.facebook),
                  googleLogin: () => _signUpUser(type: LoginType.google),
                  buttonWidth: MediaQuery.of(context).size.width * 0.15,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
