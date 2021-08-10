import 'package:flutter/material.dart';

import '../utils/themes.dart';

class InputTextField extends StatelessWidget {
  final TextEditingController chatInputController;
  final void Function() onSend;
  final String hintText;
  const InputTextField({
    Key key,
    @required this.chatInputController,
    @required this.onSend,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      controller: chatInputController,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        fillColor: Colors.white,
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 10,
        ),
        hintText: this.hintText,
        hintStyle: kTextStyle.copyWith(
          fontWeight: FontWeight.normal,
          color: Colors.grey[400],
        ),
        alignLabelWithHint: true,
        suffixIcon: Padding(
          padding: EdgeInsets.all(5.0),
          child: CircleAvatar(
            radius: 20.0,
            backgroundColor: kTealColor,
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: onSend,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
