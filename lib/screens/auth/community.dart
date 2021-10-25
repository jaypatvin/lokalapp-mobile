import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../providers/auth.dart';
import '../../widgets/screen_loader.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/themes.dart';
import '../bottom_navigation.dart';
import 'components/auth_input_form.dart';
import 'components/sso_block.dart';
import 'profile_registration.dart';

enum LoginType { email, google, facebook }

class Community extends StatefulWidget {
  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> with ScreenLoader {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _signUpUser({
    required LoginType type,
    String? email,
    String? password,
  }) async {
    final auth = context.read<Auth>();
    try {
      switch (type) {
          case LoginType.email:
            await auth.signUp(email!, password!);
            break;
          case LoginType.google:
            await auth.loginWithGoogle();
            break;
          case LoginType.facebook:
            await auth.loginWithFacebook();
            break;
          default:
        }

      if (auth.user == null) {
        int count = 0;
        Navigator.popUntil(context, (_) => count++ >= 2);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileRegistration()),
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigation()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      switch (e.code) {
      }
    } catch (e) {
      // TODO: do something with error
      print(e);
    }
  }

  @override
  Widget screen(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AnimatedContainer(
            width: double.infinity,
            height: bottom == 0 ? 280.0.h : 150.h,
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
                if (!_formKey.currentState!.validate()) return;
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
