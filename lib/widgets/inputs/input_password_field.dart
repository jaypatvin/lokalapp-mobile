import 'package:flutter/material.dart';

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
    super.key,
    this.focusNode,
    this.controller,
    this.onChanged,
    this.isPasswordVisible = false,
    this.displaySignInError = false,
    this.errorMessage = 'Password is incorrect.',
    this.onPasswordVisibilityChanged,
    this.fillColor = Colors.white,
    this.hintText = 'Password',
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      autocorrect: false,
      obscureText: !isPasswordVisible,
      controller: controller,
      onChanged: onChanged,
      style:
          Theme.of(context).textTheme.subtitle2?.copyWith(color: Colors.black),
      decoration: InputDecoration(
        fillColor: fillColor,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
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
        hintStyle:
            Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 21),
        errorText: displaySignInError ? errorMessage : null,
      ),
    );
  }
}
