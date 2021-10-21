import 'package:flutter/material.dart';

const kTealColor = const Color(0xFF09A49A);
const kNavyColor = const Color(0xFF103045);
const kPinkColor = const Color(0xFFCC3752);
const kPurpleColor = const Color(0xFF57183F);
const kOrangeColor = const Color(0xFFFF7A00);
const kInviteScreenColor = const Color(0xFFF1FAFF);
const kTextFieldBorderColor = const Color(0xFFF2F2F2);
const kYellowColor = const Color(0xffFFC700);
const kKeyboardActionHeight = 45.0;

const kInputDecoration = const InputDecoration(
  filled: true,
  isDense: true,
  enabledBorder: const OutlineInputBorder(
    borderRadius: const BorderRadius.all(
      Radius.circular(30.0),
    ),
    borderSide: const BorderSide(color: Colors.transparent),
  ),
  contentPadding: const EdgeInsets.symmetric(
    horizontal: 25,
    vertical: 10,
  ),
  hintStyle: const TextStyle(
    color: Color(0xFFBDBDBD),
    fontFamily: "Goldplay",
    fontWeight: FontWeight.normal,
  ),
  alignLabelWithHint: true,
  border: const OutlineInputBorder(
    borderRadius: const BorderRadius.all(
      Radius.circular(
        30.0,
      ),
    ),
  ),
  fillColor: Colors.white,
  errorBorder: const OutlineInputBorder(
    borderRadius: const BorderRadius.all(
      Radius.circular(30.0),
    ),
    borderSide: const BorderSide(color: kPinkColor),
  ),
  errorStyle: TextStyle(color: kPinkColor, fontWeight: FontWeight.w500),
);
