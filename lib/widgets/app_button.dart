import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants/themes.dart';

class AppButton extends StatelessWidget {
  const AppButton._({
    required this.text,
    required this.isFilled,
    this.color = kTealColor,
    this.onPressed,
    this.textStyle,
  });

  factory AppButton.custom({
    required String text,
    bool isFilled = false,
    Color color = kTealColor,
    void Function()? onPressed,
    TextStyle? textStyle,
  }) {
    return AppButton._(
      text: text,
      color: color,
      onPressed: onPressed,
      textStyle: textStyle,
      isFilled: isFilled,
    );
  }

  factory AppButton.filled({
    required String text,
    Color color = kTealColor,
    void Function()? onPressed,
    TextStyle? textStyle,
  }) {
    return AppButton._(
      text: text,
      color: color,
      onPressed: onPressed,
      textStyle: textStyle,
      isFilled: true,
    );
  }

  factory AppButton.transparent({
    required String text,
    Color color = kTealColor,
    void Function()? onPressed,
    TextStyle? textStyle,
  }) {
    return AppButton._(
      text: text,
      isFilled: false,
      color: color,
      onPressed: onPressed,
      textStyle: textStyle,
    );
  }

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
  final void Function()? onPressed;

  /// The style to be applied to the Button Label.
  ///
  /// Will be merged with:
  /// ```
  /// TextStyle(
  /// fontFamily: "Goldplay",
  /// fontSize: 16,
  /// fontWeight: FontWeight.w600,
  /// ) ```
  final TextStyle? textStyle;

  // const AppButton(
  //   this.text,
  //   this.color,
  //   this.isFilled,
  //   this.onPressed, {
  //   this.textStyle,
  // });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 0.0,
        primary: isFilled ? color : Colors.transparent,
        minimumSize: Size(0, 40.0.h),
        side: BorderSide(color: color),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Goldplay',
          fontSize: 16.0.sp,
          fontWeight: FontWeight.w600,
          color: isFilled ? Colors.white : color,
        ).merge(textStyle),
      ),
    );
  }
}
