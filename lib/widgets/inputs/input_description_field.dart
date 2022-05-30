import 'package:flutter/material.dart';

class InputDescriptionField extends StatelessWidget {
  final int maxLines;
  final Function(String)? onChanged;
  final String? errorText;
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const InputDescriptionField({
    this.maxLines = 10,
    this.onChanged,
    this.errorText,
    this.hintText,
    this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.all(12.w),
      height: maxLines * 12.0,
      color: Colors.transparent,
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        onChanged: onChanged,
        cursorColor: Colors.black,
        keyboardType: TextInputType.multiline,
        maxLines: maxLines,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          errorText: errorText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 21),
          hintText: hintText,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyText2
              ?.copyWith(color: Colors.grey),
        ),
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}
