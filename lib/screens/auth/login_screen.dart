import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../providers/categories.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../providers/users.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/overlays/screen_loader.dart';
import '../bottom_navigation.dart';
import 'components/auth_input_form.dart';
import 'components/sso_block.dart';
import 'invite_screen.dart';

enum LoginType { email, google, facebook, apple }

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with ScreenLoader<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isAuth = false;
  final _formKey = GlobalKey<FormState>();
  Map<String, String>? account;
  bool _signInError = false;

  Future<void> _logInUser({
    required LoginType type,
    String? email,
    String? password,
  }) async {
    FocusScope.of(context).unfocus();
    // CurrentUser user = context.read<Auth>().user!;
    // UserAuth auth = Provider.of<UserAuth>(context, listen: false);
    final auth = context.read<Auth>();
    try {
      switch (type) {
        case LoginType.email:
          await auth.loginWithEmail(email!, password!);
          break;
        case LoginType.google:
          await auth.loginWithGoogle();
          break;
        case LoginType.facebook:
          await auth.loginWithFacebook();
          break;
        case LoginType.apple:
          await auth.loginWithApple();
          break;
      }

      if (auth.user != null) {
        await performFuture(() async {
          await context.read<Shops>().fetch();
          await context.read<Products>().fetch();
          await context.read<Users>().fetch();
          await context.read<Categories>().fetch();
        });
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
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
        case "wrong-password":
          setState(() {
            _signInError = true;
          });
          break;
        case "user-not-found":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => InvitePage()),
          );
          break;
        default:
          throw e.message!;
      }
    } catch (e) {
      final snackBar = SnackBar(content: Text('Error Logging In'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget screen(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false, // added as above is deprecated
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AnimatedContainer(
            color: kYellowColor,
            height: bottom == 0 ? 280.0.h : 150.h,
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
                  onFormSubmit: () async {
                    setState(() {
                      _signInError = false;
                    });
                    if (!_formKey.currentState!.validate()) return;

                    await performFuture<void>(
                      () async => await _logInUser(
                        type: LoginType.email,
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      ),
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
                  fbLogin: () async => await performFuture(
                      () async => await _logInUser(type: LoginType.facebook)),
                  googleLogin: () async => await performFuture(
                      () async => await _logInUser(type: LoginType.google)),
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
