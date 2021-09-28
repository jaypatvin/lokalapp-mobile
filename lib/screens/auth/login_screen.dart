import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/activities.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../providers/user.dart';
import '../../providers/user_auth.dart';
import '../../providers/users.dart';
import '../../utils/themes.dart';
import '../../widgets/sso_block.dart';
import '../bottom_navigation.dart';
import 'components/auth_input_form.dart';
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
  bool _signInError = false;

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
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _logInUser({
    @required LoginType type,
    String email,
    String password,
  }) async {
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
          _authStatus = await auth.loginWithGoogle();
          break;
        case LoginType.facebook:
          _authStatus = await auth.loginWithFacebook();
          break;
        default:
      }
      if (_authStatus == AuthStatus.Success) {
        await user.fetch(auth.user);
        if (user.state == UserState.LoggedIn) {
          context.read<Activities>().fetch();
          context.read<Shops>().fetch();
          context.read<Products>().fetch();
          context.read<Users>().fetch();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigation()),
            (route) => false,
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => InvitePage()),
          );
        }
      } else if (_authStatus == AuthStatus.UserNotFound) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InvitePage()),
        );
      } else if (_authStatus == AuthStatus.InvalidPassword) {
        setState(() {
          _signInError = true;
        });
        Navigator.pop(context);
      }
    } catch (e) {
      // TODO: do something with error
      Navigator.pop(context);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false, // added as above is deprecated
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AnimatedContainer(
            color: kYellowColor,
            height: 330.0.h - bottom, //bottom == 0 ? 330.0.h : 220.0.h,
            duration: Duration(milliseconds: 100),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: "home",
                        child: Image.asset("assets/Lokalv2.png"),
                      ),
                      Hero(
                        tag: "lokal",
                        child: Text(
                          "LOKAL",
                          style: TextStyle(
                            color: kOrangeColor,
                            fontSize: 24.0.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Hero(
                        tag: "plaza",
                        child: Text(
                          "Your neighborhood plaza",
                          style: TextStyle(
                            fontSize: 14.0.sp,
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
            ),
          ),
          SizedBox(height: 30.0.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0.w),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AuthInputForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  submitButtonLabel: "SIGN IN",
                  displaySignInError: _signInError,
                  onFormChanged: () => setState(() {}),
                  onFormSubmit: () {
                    setState(() {
                      _signInError = false;
                    });
                    if (!_formKey.currentState.validate()) return;
                    _logInUser(
                      type: LoginType.email,
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    );
                  },
                ),
                SizedBox(height: 10.0.h),
                InkWell(
                  child: Text(
                    "FORGOT PASSWORD?",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  onTap: () {},
                ),
                SizedBox(height: 20.0.h),
                SocialBlock(
                  fbLogin: () => _logInUser(type: LoginType.facebook),
                  googleLogin: () => _logInUser(type: LoginType.google),
                  buttonWidth: 50.0.w,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
