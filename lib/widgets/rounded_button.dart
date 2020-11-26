import 'package:flutter/material.dart';
import 'package:lokalapp/utils/themes.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final double minWidth;

  RoundedButton({this.label, this.onPressed, this.minWidth = 113.0});

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
            ),
          ),
        ),
      ),
    );
  }
}
