import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool enabled;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;
  const SearchTextField({
    Key? key,
    this.controller,
    this.hintText = 'Search',
    this.enabled = false,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.search,
      enabled: enabled,
      controller: controller,
      onChanged: onChanged,
      onTap: onTap,
      style: TextStyle(fontSize: 16.0.sp),
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        isDense: true, // Added this
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(25.0.r)),
        ),
        fillColor: const Color(0xffF2F2F2),
        prefixIcon: Icon(
          Icons.search,
          color: const Color(0xffBDBDBD),
          size: 24.0.sp,
        ),
        hintText: hintText,
        labelStyle: TextStyle(fontSize: 20.0.sp),
        contentPadding: const EdgeInsets.symmetric(vertical: 1),
        hintStyle: const TextStyle(
          color: Color(0xffBDBDBD),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
