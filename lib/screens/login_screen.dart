import 'package:firebase_auth/firebase_auth.dart';
import 'package:lokalapp/root/root.dart';
import 'package:lokalapp/states/currentUser.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lokalapp/screens/profile_registration.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:lokalapp/widgets/rounded_button.dart';
import 'package:lokalapp/widgets/social_button.dart';
import 'package:lokalapp/models/user.dart';
import 'package:lokalapp/screens/home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lokalapp/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum LoginType { email, google }
// Users currentUser;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Color _kMainColor = const Color(0xFFFFC700);
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isAuth = false;

  FirebaseAuth _auth = FirebaseAuth.instance;
  String _email;
  String _password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController.addListener(() {
      this._email = _emailController.text;
    });
    _passwordController.addListener(() {
      this._password = _passwordController.text;
    });
  }

  void _logInUserWithEmail(
      {@required LoginType type,
      String email,
      String password,
      BuildContext context}) async {
    CurrentUser _users = Provider.of<CurrentUser>(context, listen: false);
    try {
      String _returnString;
      switch (type) {
        case LoginType.email:
          _returnString = await _users.loginUserWithEmail(email, password);
          break;
        case LoginType.google:
          _returnString = await _users.loginUserWithGoogle();
          break;
        default:
      }

      if (_returnString == "success") {
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => Home()));
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
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
      onTap: () {},
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
      onTap: () {},
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

  Widget buildSocialBlock() {
    return Column(
      children: [
        SocialButton(
          label: "Sign in with Facebook",
          onPressed: () {},
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

  // Future<UserCredential> signInWithGoogle() async {
  //   final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser.authentication;
  //
  //   final GoogleAuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

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
