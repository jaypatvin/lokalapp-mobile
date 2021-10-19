import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants/themes.dart';

class PasswordInputField extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool isPasswordVisible;
  final bool displaySignInError;
  final void Function()? onPasswordVisibilityChanged;
  final void Function(String)? onChanged;
  final String errorMessage;
  final Color fillColor;
  const PasswordInputField({
    Key? key,
    this.focusNode,
    this.controller,
    this.onChanged,
    this.isPasswordVisible = false,
    this.displaySignInError = false,
    this.errorMessage = 'Password is incorrect.',
    this.onPasswordVisibilityChanged,
    this.fillColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: this.focusNode,
      autocorrect: false,
      obscureText: !this.isPasswordVisible,
      controller: this.controller,
      onChanged: this.onChanged,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16.0.sp,
      ),
      decoration: new InputDecoration(
        fillColor: this.fillColor,
        border: new OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0.r)),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            !this.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: kOrangeColor,
          ),
          onPressed: this.onPasswordVisibilityChanged,
        ),
        isDense: false,
        filled: true,
        alignLabelWithHint: true,
        hintText: 'Password',
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0.w),
        errorText: this.displaySignInError ? this.errorMessage : null,
      ),
    );
  }
}
