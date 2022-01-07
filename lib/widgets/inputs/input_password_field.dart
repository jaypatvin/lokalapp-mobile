import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants/themes.dart';

class InputPasswordField extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool isPasswordVisible;
  final bool displaySignInError;
  final void Function()? onPasswordVisibilityChanged;
  final void Function(String)? onChanged;
  final String errorMessage;
  final Color fillColor;
  final String hintText;
  const InputPasswordField({
    Key? key,
    this.focusNode,
    this.controller,
    this.onChanged,
    this.isPasswordVisible = false,
    this.displaySignInError = false,
    this.errorMessage = 'Password is incorrect.',
    this.onPasswordVisibilityChanged,
    this.fillColor = Colors.white,
    this.hintText = 'Password',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      autocorrect: false,
      obscureText: !isPasswordVisible,
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
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            !isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: kOrangeColor,
          ),
          onPressed: onPasswordVisibilityChanged,
        ),
        isDense: false,
        filled: true,
        alignLabelWithHint: true,
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0.w),
        errorText: displaySignInError ? errorMessage : null,
      ),
    );
  }
}
