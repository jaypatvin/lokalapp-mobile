import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants/themes.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    this.focusNode,
    this.controller,
    this.onChanged,
    this.validator,
    this.hintText,
    this.errorText,
    this.fillColor = const Color(0xFFF2F2F2),
    this.displayErrorBorder = false,
    this.enabled = true,
    this.keyboardType,
    this.style,
    this.hintStyle,
  }) : super(key: key);

  final FocusNode? focusNode;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  final String? hintText;
  final String? errorText;
  final Color fillColor;
  final TextInputType? keyboardType;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final bool displayErrorBorder;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: this.enabled,
      autocorrect: false,
      focusNode: this.focusNode,
      keyboardType: this.keyboardType,
      controller: this.controller,
      onChanged: this.onChanged,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16.0.sp,
      ).merge(this.style),
      decoration: InputDecoration(
        fillColor: this.fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0.r)),
          borderSide: displayErrorBorder
              ? BorderSide(color: kPinkColor)
              : BorderSide.none,
        ),
        isDense: false,
        filled: true,
        alignLabelWithHint: true,
        hintText: this.hintText,
        errorText: this.errorText,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0.w),
        hintStyle: this.hintStyle,
      ),
      validator: this.validator,
    );
  }
}
