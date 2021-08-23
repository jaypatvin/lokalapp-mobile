import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Color color;
  final bool isFilled;
  final void Function() onPressed;
  final TextStyle textStyle;
  const AppButton(
    this.text,
    this.color,
    this.isFilled,
    this.onPressed, {
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlatButton(
        height: MediaQuery.of(context).size.height * 0.05,
        color: isFilled ? this.color : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: this.color),
        ),
        textColor: isFilled ? Colors.white : this.color,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "Goldplay",
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ).merge(this.textStyle),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
