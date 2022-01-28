import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpecialInstructionsTextField extends StatelessWidget {
  final int maxLines;
  final TextEditingController controller;
  final FocusNode? focusNode;
  const SpecialInstructionsTextField({
    Key? key,
    required this.controller,
    this.focusNode,
    this.maxLines = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxLines * 15.0.sp,
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
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          // errorBorder: InputBorder.none,
          // disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 24.0.w,
            vertical: 24.0.h,
          ),
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
