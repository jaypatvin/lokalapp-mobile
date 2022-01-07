import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:validators/validators.dart';

import '../../utils/constants/themes.dart';

class InputEmailField extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? errorMessage;
  final bool displayErrorBorder;
  final bool validate;
  final Color fillColor;
  const InputEmailField({
    Key? key,
    this.focusNode,
    this.controller,
    this.onChanged,
    this.errorMessage,
    this.displayErrorBorder = false,
    this.validate = false,
    this.fillColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16.0.sp,
      ),
      decoration: InputDecoration(
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0.r)),
          borderSide: displayErrorBorder
              ? const BorderSide(color: kPinkColor)
              : BorderSide.none,
        ),
        isDense: false,
        filled: true,
        alignLabelWithHint: true,
        hintText: 'Email',
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0.w),
      ),
      validator: (email) => validate && isEmail(email!)
          ? null
          : errorMessage ?? 'Enter a valid email',
    );
  }
}
