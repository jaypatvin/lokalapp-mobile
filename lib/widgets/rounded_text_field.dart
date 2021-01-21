import 'package:flutter/material.dart';

class RoundedTextField extends StatefulWidget {
  final String hintText;
  final Function onTap;

  RoundedTextField({this.hintText, this.onTap});

  @override
  _RoundedTextFieldState createState() => _RoundedTextFieldState();
}

class _RoundedTextFieldState extends State<RoundedTextField> {
  String inputValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(40.0),
      child: TextField(
        onTap: widget.onTap,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 10,
          ),
          hintText: widget.hintText,
          alignLabelWithHint: true,
          border: const OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(
                30.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
