import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({this.color, this.buttonTitle, this.onPressed});
  final Color color;
  final String buttonTitle;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 1.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 190.0,
          height: 25.0,
          child: Text(
            buttonTitle,
            style: TextStyle(
                color: Color(0XFF103045),
                fontWeight: FontWeight.bold,
                fontFamily: "Goldplay",
                fontSize: 20.0),
          ),
        ),
      ),
    );
  }
}
