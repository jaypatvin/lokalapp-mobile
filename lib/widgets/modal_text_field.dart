import 'package:flutter/material.dart';
import 'package:lokalapp/utils/themes.dart';

class ModalTextField extends StatefulWidget {
  final String hintText;
  final Function onPressed;
  ModalTextField({this.hintText, this.onPressed});
  @override
  _ModalTextFieldState createState() => _ModalTextFieldState();
}

class _ModalTextFieldState extends State<ModalTextField> {
  String inputValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20.0, 20.0, 20.0, MediaQuery.of(context).viewInsets.bottom + 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: TextField(
        autofocus: true,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 10,
          ),
          hintText: widget.hintText,
          alignLabelWithHint: true,
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  30.0,
                ),
              ),
              borderSide: BorderSide(
                color: kTextFieldBorderColor,
              )),
          suffixIcon: Padding(
            padding: EdgeInsets.all(5.0),
            child: CircleAvatar(
              radius: 20.0,
              backgroundColor: kTealColor,
              child: IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
