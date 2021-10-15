import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputDescription extends StatelessWidget {
  final int maxLines;
  final Function(String)? onChanged;
  final String? errorText;
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  InputDescription({
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
      margin: EdgeInsets.all(12.w),
      height: maxLines * 12.0.sp,
      color: Colors.transparent,
      child: TextField(
        focusNode: this.focusNode,
        controller: this.controller,
        onChanged: this.onChanged,
        cursorColor: Colors.black,
        keyboardType: TextInputType.multiline,
        maxLines: maxLines,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          errorText: this.errorText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey.shade400,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 1, color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 1, color: Colors.grey.shade400),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.0.w,
            vertical: 20.0.h,
          ),
          hintText: this.hintText,
          hintStyle: Theme.of(context).textTheme.bodyText2,
        ),
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
