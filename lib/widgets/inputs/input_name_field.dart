import 'package:flutter/material.dart';

class InputNameField extends StatelessWidget {
  final Function(String)? onChanged;
  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Color fillColor;
  final TextInputType? keyboardType;
  final TextStyle? style;

  const InputNameField({
    this.onChanged,
    this.hintText,
    this.errorText,
    this.controller,
    this.fillColor = const Color(0xFFF2F2F2),
    this.keyboardType,
    this.style,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        fillColor: fillColor,
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
              color: const Color(0xFFBDBDBD),
            ),
        alignLabelWithHint: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
        errorText: errorText,
      ),
      style: Theme.of(context).textTheme.subtitle2?.merge(style),
    );
  }
}
