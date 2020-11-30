import 'package:lokalapp/utils/themes.dart';
import "package:flutter/material.dart";

class RoundedButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final double minWidth;
  final double fontSize;
  final String fontFamily;
  final fontWeight;
  RoundedButton(
      {this.label,
      this.onPressed,
      this.minWidth = 113.0,
      this.fontFamily,
      this.fontSize,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        color: kTealColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: this.onPressed,
          minWidth: this.minWidth,
          child: Text(
            this.label,
            style: TextStyle(
              color: kNavyColor,
              fontSize: fontSize,
              fontFamily: fontFamily,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}
