import 'package:flutter/material.dart';
import 'package:lokalapp/utils/themes.dart';

class SocialButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final double minWidth;

  SocialButton({this.label, this.onPressed, this.minWidth = 113.0});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        side: BorderSide(color: kTealColor),
      ),
      minWidth: this.minWidth,
      child: Text(
        this.label,
        style: TextStyle(
          color: kTealColor,
          fontFamily: "Goldplay",
          fontWeight: FontWeight.w800,
          fontSize: 14.0,
        ),
      ),
    );
  }
}
