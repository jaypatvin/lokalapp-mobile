import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  /// Button Label
  final String text;

  /// Sets the button Color.
  ///
  /// If the property `isFilled` is true, this will be discarded and replaced with white.
  /// (No point in setting background color to white! Just set `isFilled` to false)
  final Color color;

  /// Determines if the button will be filled with the "color" property
  final bool isFilled;

  /// The function to be called when this button is pressed.
  final void Function() onPressed;

  /// The style to be applied to the Button Label.
  ///
  /// Will be merged with:
  /// ``` TextStyle(
  /// fontFamily: "Goldplay",
  /// fontSize: 14,
  /// fontWeight: FontWeight.w700,
  /// ) ```
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
    return FlatButton(
      //height: MediaQuery.of(context).size.height * 0.05,
      color: isFilled ? this.color : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: this.color),
      ),
      textColor: isFilled ? Colors.white : this.color,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Goldplay",
          fontSize: 14.0.sp,
          fontWeight: FontWeight.w600,
        ).merge(this.textStyle),
      ),
      onPressed: onPressed,
    );
  }
}
