import 'package:flutter/material.dart';

class SpecialInstructionsTextField extends StatelessWidget {
  final int maxLines;
  final TextEditingController controller;
  final FocusNode? focusNode;
  const SpecialInstructionsTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.maxLines = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 151,
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        cursorColor: Colors.black,
        keyboardType: TextInputType.multiline,
        maxLines: maxLines,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          // errorBorder: InputBorder.none,
          // disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.all(21),
          hintText: 'e.g no bell peppers, please.',
          hintStyle: Theme.of(context)
              .textTheme
              .bodyText2
              ?.copyWith(color: const Color(0xFFBDBDBD)),
        ),
      ),
    );
  }
}
