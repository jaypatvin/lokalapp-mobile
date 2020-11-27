import 'package:flutter/material.dart';
import 'package:lokalapp/utils/themes.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final Function onPressed;

  RoundedButton({this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      color: kTealColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      minWidth: MediaQuery.of(context).size.width / 3,
      child: Text(
        this.label,
        style: TextStyle(
          color: kNavyColor,
          fontFamily: "Goldplay",
          fontWeight: FontWeight.w800,
          fontSize: 14.0,
        ),
      ),
    );
  }
}