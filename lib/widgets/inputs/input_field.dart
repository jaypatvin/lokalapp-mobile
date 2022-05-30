import 'package:flutter/material.dart';

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
    this.initialValue,
  }) : super(key: key);

  final FocusNode? focusNode;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  final String? hintText;
  final String? errorText;
  final String? initialValue;
  final Color fillColor;
  final TextInputType? keyboardType;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final bool displayErrorBorder;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      autocorrect: false,
      focusNode: focusNode,
      keyboardType: keyboardType,
      initialValue: initialValue,
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Colors.black,
      ).merge(style),
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
        errorText: errorText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 25.0),
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Colors.grey,
        ).merge(hintStyle),
      ),
      validator: validator,
    );
  }
}
