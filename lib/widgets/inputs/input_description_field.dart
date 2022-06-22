import 'package:flutter/material.dart';

class InputDescriptionField extends StatelessWidget {
  final int maxLines;
  final int minLines;
  final Function(String)? onChanged;
  final String? errorText;
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final EdgeInsets contentPadding;
  final Color fillColor;
  final InputBorder border;
  final InputBorder focusedBorder;
  final InputBorder enabledBorder;

  const InputDescriptionField({
    Key? key,
    this.maxLines = 10,
    this.minLines = 7,
    this.onChanged,
    this.errorText,
    this.hintText,
    this.controller,
    this.focusNode,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 20, vertical: 21),
    this.fillColor = Colors.white,
    this.border = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
    ),
    this.focusedBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
    ),
    this.enabledBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      onChanged: onChanged,
      cursorColor: Colors.black,
      keyboardType: TextInputType.multiline,
      maxLines: maxLines,
      minLines: minLines,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        errorText: errorText,
        border: border,
        focusedBorder: focusedBorder,
        enabledBorder: enabledBorder,
        contentPadding: contentPadding,
        hintText: hintText,
        hintStyle: Theme.of(context)
            .textTheme
            .bodyText2
            ?.copyWith(color: const Color(0xFF828282)),
      ),
      style: Theme.of(context).textTheme.bodyText2,
    );
  }
}
