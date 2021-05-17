import 'package:flutter/material.dart';

class InputName extends StatelessWidget {
  final Function(String) onChanged;
  final String hintText;
  final String errorText;
  final TextEditingController controller;
  final Color fillColor;

  InputName({
    this.onChanged,
    this.hintText,
    this.errorText,
    this.controller,
    this.fillColor = const Color(0xFFF2F2F2),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: TextField(
        controller: this.controller,
        onChanged: this.onChanged,
        decoration: InputDecoration(
          fillColor: this.fillColor,
          filled: true,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 13,
          ),
          hintText: this.hintText,
          hintStyle: TextStyle(
            fontFamily: "GoldplayBold",
            fontSize: 14,
            color: Color(0xFFBDBDBD),
            // fontWeight: FontWeight.w500
          ),
          alignLabelWithHint: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: const BorderRadius.all(
              Radius.circular(
                30.0,
              ),
            ),
          ),
          errorText: this.errorText,
        ),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontFamily: "GoldplayBold",
          fontSize: 20.0,
          // fontWeight: FontWeight.w500
        ),
      ),
    );
  }
}
