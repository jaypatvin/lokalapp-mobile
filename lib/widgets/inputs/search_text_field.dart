import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool enabled;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  const SearchTextField({
    Key? key,
    this.controller,
    this.hintText = "Search",
    this.enabled = false,
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      height: 40.0.h,
      child: TextField(
        enabled: this.enabled,
        controller: this.controller,
        onChanged: this.onChanged,
        onTap: this.onTap,
        style: TextStyle(fontSize: 16.0.sp),
        decoration: InputDecoration(
          isDense: true, // Added this
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(25.0.r)),
          ),
          fillColor: Color(0xffF2F2F2),
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xffBDBDBD),
            size: 23.0.sp,
          ),
          hintText: this.hintText,
          labelStyle: TextStyle(fontSize: 20.0.sp),
          contentPadding: const EdgeInsets.symmetric(vertical: 1),
          hintStyle: TextStyle(color: Color(0xffBDBDBD)),
        ),
      ),
    );
  }
}