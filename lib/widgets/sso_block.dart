import 'package:flutter/material.dart';
import 'package:lokalapp/services/database.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:lokalapp/widgets/sso_button.dart';

class SocialBlock extends StatelessWidget {
  final String label;
  final double buttonWidth;

  final Function fbLogin;
  final Function appleLogin;
  final Function googleLogin;

  const SocialBlock(
      {this.label,
      this.buttonWidth,
      this.fbLogin,
      this.appleLogin,
      this.googleLogin});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: buttonWidth * 0.5),
      child: Column(
        children: [
          Text(
            "Sign in with",
            style: TextStyle(
              fontFamily: "Goldplay",
              fontSize: buttonWidth * 0.30,
            ),
          ),
          SizedBox(
            height: buttonWidth * 0.10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SocialButton(
                image: AssetImage("assets/sso/fb_logo.png"),
                onTap: this.fbLogin,
                width: this.buttonWidth,
              ),
              SocialButton(
                image: AssetImage("assets/sso/apple_logo.png"),
                onTap: this.appleLogin,
                width: this.buttonWidth,
              ),
              SocialButton(
                image: AssetImage("assets/sso/google_logo.png"),
                onTap: this.googleLogin,
                width: this.buttonWidth,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
