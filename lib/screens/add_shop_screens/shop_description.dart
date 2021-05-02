import 'package:flutter/material.dart';

class ShopDescription extends StatefulWidget {
  final Function onChanged;
  final String hintText;
  final String errorText;
  final TextEditingController descriptionController;
  ShopDescription(
      {this.descriptionController,
      this.onChanged,
      this.hintText,
      this.errorText});
  @override
  _ShopDescriptionState createState() => _ShopDescriptionState();
}

class _ShopDescriptionState extends State<ShopDescription> {
  final maxLines = 10;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      height: maxLines * 15.0,
      color: Colors.transparent,
      child: TextField(
        controller: widget.descriptionController,
        onChanged: widget.onChanged,
        cursorColor: Colors.black,
        keyboardType: TextInputType.multiline,
        maxLines: maxLines,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          errorText: widget.errorText,
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
          hintText: widget.hintText,
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
