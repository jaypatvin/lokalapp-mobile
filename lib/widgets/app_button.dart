import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants/themes.dart';

class AppButton extends StatelessWidget {
  const AppButton._({
    required this.child,
    required this.isFilled,
    this.color = kTealColor,
    this.onPressed,
    this.textStyle,
  });

  /// AppButton builder to be used for custom button child.
  factory AppButton.customChild({
    required Widget child,
    bool isFilled = false,
    Color color = kTealColor,
    void Function()? onPressed,
  }) {
    return AppButton._(
      isFilled: isFilled,
      color: color,
      onPressed: onPressed,
      child: child,
    );
  }

  /// AppButton builder to be used when you want flexibility for the design.
  factory AppButton.custom({
    required String text,
    bool isFilled = false,
    Color color = kTealColor,
    void Function()? onPressed,
    TextStyle? textStyle,
  }) {
    final _child = Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Goldplay',
        fontSize: 16.0.sp,
        fontWeight: FontWeight.w600,
        color: isFilled ? Colors.white : color,
      ).merge(textStyle),
    );

    return AppButton._(
      color: color,
      onPressed: onPressed,
      textStyle: textStyle,
      isFilled: isFilled,
      child: _child,
    );
  }

  /// AppButton builder to be used for filled button.
  factory AppButton.filled({
    required String text,
    Color color = kTealColor,
    void Function()? onPressed,
    TextStyle? textStyle,
  }) {
    final _child = Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Goldplay',
        fontSize: 16.0.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ).merge(textStyle),
    );

    return AppButton._(
      color: color,
      onPressed: onPressed,
      textStyle: textStyle,
      isFilled: true,
      child: _child,
    );
  }

  /// AppButton builder to be used for a transparent.
  factory AppButton.transparent({
    required String text,
    Color color = kTealColor,
    void Function()? onPressed,
    TextStyle? textStyle,
  }) {
    final _child = Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Goldplay',
        fontSize: 16.0.sp,
        fontWeight: FontWeight.w600,
        color: color,
      ).merge(textStyle),
    );
    return AppButton._(
      isFilled: false,
      color: color,
      onPressed: onPressed,
      textStyle: textStyle,
      child: _child,
    );
  }

  final Widget child;

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

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 0.0,
        primary: isFilled ? color : Colors.transparent,
        minimumSize: const Size(0, kMinInteractiveDimension),
        side: BorderSide(color: color),
      ),
      child: child,
    );
  }
}
