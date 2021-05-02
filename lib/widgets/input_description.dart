import 'package:flutter/material.dart';

class InputDescription extends StatelessWidget {
  final int maxLines;
  final Function(String) onChanged;
  final String errorText;
  final String hintText;

  InputDescription({
    this.maxLines = 10,
    @required this.onChanged,
    this.errorText,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      height: maxLines * 15.0,
      color: Colors.transparent,
      child: TextField(
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
              color: Colors.grey.shade500,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
          ),
          // errorBorder: InputBorder.none,
          // disabledBorder: InputBorder.none,
          contentPadding:
              EdgeInsets.only(left: 18, bottom: 11, top: 30, right: 15),
          hintText: this.hintText,
          hintStyle: TextStyle(
            color: Color(0xFFBDBDBD),
            fontSize: 14,
            fontFamily: "GoldplayBold",
            // fontWeight: FontWeight.w500,
          ),
        ),
        style: TextStyle(
          fontFamily: "GoldplayBold",
        ),
      ),
    );
  }
}
