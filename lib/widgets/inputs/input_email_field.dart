import 'package:flutter/material.dart';
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
  final String hintText;
  const InputEmailField({
    super.key,
    this.focusNode,
    this.controller,
    this.onChanged,
    this.errorMessage,
    this.displayErrorBorder = false,
    this.validate = false,
    this.fillColor = Colors.white,
    this.hintText = 'Email Address',
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      onChanged: onChanged,
      style:
          Theme.of(context).textTheme.subtitle2?.copyWith(color: Colors.black),
      decoration: InputDecoration(
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
          borderSide: displayErrorBorder
              ? const BorderSide(color: kPinkColor)
              : BorderSide.none,
        ),
        isDense: false,
        filled: true,
        alignLabelWithHint: true,
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 21),
        hintStyle:
            Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.grey),
      ),
      validator: (email) => validate && isEmail(email!)
          ? null
          : errorMessage ?? 'Enter a valid email',
    );
  }
}
