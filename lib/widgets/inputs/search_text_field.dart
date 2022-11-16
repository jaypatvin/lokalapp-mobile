import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool enabled;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;
  const SearchTextField({
    super.key,
    this.controller,
    this.hintText = 'Search',
    this.enabled = false,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.search,
      enabled: enabled,
      controller: controller,
      onChanged: onChanged,
      onTap: onTap,
      style: Theme.of(context).textTheme.bodyText1,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        isDense: true, // Added this
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        fillColor: const Color(0xffF2F2F2),
        prefixIcon: const Icon(
          Icons.search,
          color: Color(0xffBDBDBD),
        ),
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(vertical: 1),
        hintStyle: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(color: const Color(0xFFBDBDBD)),
      ),
    );
  }
}
