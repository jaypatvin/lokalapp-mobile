import 'package:flutter/material.dart';

const kTealColor = Color(0xFF09A49A);
const kNavyColor = Color(0xFF103045);
const kPinkColor = Color(0xFFCC3752);
const kPurpleColor = Color(0xFF57183F);
const kOrangeColor = Color(0xFFFF7A00);
const kInviteScreenColor = Color(0xFFF1FAFF);
const kTextFieldBorderColor = Color(0xFFF2F2F2);
const kYellowColor = Color(0xffFFC700);
const kKeyboardActionHeight = 45.0;

const kInputDecoration = InputDecoration(
  filled: true,
  isDense: true,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(30.0),
    ),
    borderSide: BorderSide(color: Colors.transparent),
  ),
  contentPadding: EdgeInsets.symmetric(
    horizontal: 25,
    vertical: 10,
  ),
  hintStyle: TextStyle(
    color: Color(0xFFBDBDBD),
    fontFamily: 'Goldplay',
    fontWeight: FontWeight.normal,
  ),
  alignLabelWithHint: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(
        30.0,
      ),
    ),
  ),
  fillColor: Colors.white,
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(30.0),
    ),
    borderSide: BorderSide(color: kPinkColor),
  ),
  errorStyle: TextStyle(color: kPinkColor, fontWeight: FontWeight.w500),
);
