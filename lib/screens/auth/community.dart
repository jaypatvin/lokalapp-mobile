import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/user.dart';
import '../../providers/user_auth.dart';
import '../../utils/themes.dart';
import '../../widgets/sso_block.dart';
import '../bottom_navigation.dart';
import 'components/auth_input_form.dart';
import 'profile_registration.dart';

enum LoginType { email, google, facebook }

class Community extends StatefulWidget {
  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _signUpUser(
      {@required LoginType type, String email, String password}) async {
    final auth = context.read<UserAuth>();
    try {
      AuthStatus _authStatus;

      switch (type) {
        case LoginType.email:
          _authStatus = await auth.signUp(email, password);
          break;
        case LoginType.google:
          _authStatus = await auth.loginWithGoogle();
          break;
        case LoginType.facebook:
          _authStatus = await auth.loginWithFacebook();
          break;
        default:
      }
      if (_authStatus == AuthStatus.NewUser) {
        int count = 0;
        Navigator.popUntil(context, (_) => count++ >= 2);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileRegistration()),
        );
      } else if (_authStatus == AuthStatus.Success) {
        var user = Provider.of<CurrentUser>(context, listen: false);
        await user.fetch(auth.user);
        if (user.state == UserState.LoggedIn) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigation()),
            (route) => false,
          );
        } else if (user.state == UserState.NotRegistered) {
          int count = 0;
          Navigator.popUntil(context, (_) => count++ >= 2);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileRegistration()),
          );
        }
      }
    } catch (e) {
      // TODO: do something with error
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AnimatedContainer(
            width: double.infinity,
            height: bottom == 0 ? 300.h : 100.h,
            color: kYellowColor,
            duration: Duration(milliseconds: 100),
            child: SafeArea(
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
                          fontSize: 25.0.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Hero(
                    tag: "Community",
                    child: Center(
                      child: Text(
                        "White Plains",
                        style: TextStyle(
                          fontSize: 25.0.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30.0.h),
          Center(
            child: Text(
              "Create an account below",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17.0.sp,
              ),
            ),
          ),
          SizedBox(height: 20.0.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0.w),
            child: AuthInputForm(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
              submitButtonLabel: "REGISTER",
              onFormChanged: () => setState(() {}),
              onFormSubmit: () {
                if (!_formKey.currentState.validate()) return;
                _signUpUser(
                  type: LoginType.email,
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                );
              },
            ),
          ),
          SizedBox(height: 20.0.h),
          SocialBlock(
            fbLogin: () => _signUpUser(type: LoginType.facebook),
            googleLogin: () => _signUpUser(type: LoginType.google),
            buttonWidth: 50.0.w,
          ),
          //SizedBox(height: 30.0.h)
        ],
      ),
    );
  }
}
