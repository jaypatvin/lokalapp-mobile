import 'package:flutter/material.dart';
import '../utils/themes.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final double minWidth;
  final double fontSize;
  final String fontFamily;
  final double height;
  final FontWeight fontWeight;
  final Color fontColor;
  RoundedButton({
    this.label,
    this.onPressed,
    this.height,
    this.minWidth = 113.0,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.fontColor = kNavyColor,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      color: kTealColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: MaterialButton(
        onPressed: this.onPressed,
        minWidth: this.minWidth,
        height: this.height,
        child: Text(
          this.label,
          style: TextStyle(
            color: this.fontColor,
            fontSize: this.fontSize,
            fontFamily: this.fontFamily,
            fontWeight: this.fontWeight,
          ),
        ),
      ),
    );
  }
}
