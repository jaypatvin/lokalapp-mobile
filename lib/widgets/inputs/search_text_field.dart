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
    this.hintText = 'Search',
    this.enabled = false,
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      controller: controller,
      onChanged: onChanged,
      onTap: onTap,
      style: TextStyle(fontSize: 16.0.sp),
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
          size: 23.0.sp,
        ),
        hintText: hintText,
        labelStyle: TextStyle(fontSize: 20.0.sp),
        contentPadding: const EdgeInsets.symmetric(vertical: 1),
        hintStyle: const TextStyle(color: Color(0xffBDBDBD)),
      ),
    );
  }
}
