import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/screens/community.dart';
import 'package:lokalapp/widgets/rounded_text_field.dart';
import 'package:lokalapp/services/database.dart';
import 'package:lokalapp/states/currentUser.dart';
import 'package:lokalapp/widgets/modal_text_field.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:lokalapp/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class InvitePage extends StatefulWidget {
  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  TextEditingController _codeController = TextEditingController();

  void validateInviteCode(BuildContext context, String code) async {
    bool inviteCodeExists = await Database().inviteCodeExists(code);
    if (inviteCodeExists) {
      
    Navigator.push(context, MaterialPageRoute(builder: (context) => Community()));
    } else {
      //TODO: add toast "community invite code is invalid"
    }
  }

  InputDecoration _kInputDecoration = const InputDecoration(
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
    hintStyle: TextStyle(
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
  );

  bool _isTextFieldVisible = true;

  void toggleTextFieldVisibility() {
    setState(() {
      _isTextFieldVisible = !_isTextFieldVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kInviteScreenColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 40.0,
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Enter invite code",
                  style: TextStyle(
                    fontSize: 30.0,
                    color: kNavyColor,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                  "A community key is required to create an account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: kNavyColor,
                  ),
                ),
                SizedBox(
                  height: 35.0,
                ),
                TextField(
                  onTap: () {},
                  controller: _codeController,
                  style: TextStyle(
                    fontFamily: "Goldplay",
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: _kInputDecoration.copyWith(
                    hintText: "Community Key",
                    fillColor: Colors.white,
                  ),
                ),
                Visibility(
                  visible: _isTextFieldVisible,
                  child: RoundedTextField(
                    hintText: "Community Key",
                    onTap: () {
                      toggleTextFieldVisibility();
                      showModalBottomSheet(
                        barrierColor: Colors.black.withAlpha(1),
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => ModalTextField(
                          hintText: "Community Key",
                          onPressed: toggleTextFieldVisibility,
                        ),
                      ).whenComplete(toggleTextFieldVisibility);
                    },
                  ),
                ),
                SizedBox(
                  height: 35.0,
                ),
                RoundedButton(
                  label: "Join",
                  onPressed: () =>
                      validateInviteCode(context, _codeController.text),
                ),
                SizedBox(
                  height: 20.0,
                ),
                InkWell(
                    child: Text(
                      "WHAT'S A COMMUNITY KEY?",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: "Goldplay",
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: kTealColor,
                      ),
                    ),
                    onTap: () {}),
                Visibility(
                  visible: _isTextFieldVisible,
                  child: RoundedButton(
                    label: "Join",
                    onPressed: () {},
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
