import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Container(
      margin: EdgeInsets.all(5.0.w),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          fillColor: fillColor,
          filled: true,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 13.h,
          ),
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
        style: Theme.of(context).textTheme.headline6!.merge(style),
      ),
    );
  }
}
