import 'package:flutter/material.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:lokalapp/widgets/modal_text_field.dart';
import 'package:lokalapp/widgets/rounded_button.dart';
import 'package:lokalapp/widgets/rounded_text_field.dart';

class InvitePage extends StatefulWidget {
  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
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
              Visibility(
                visible: _isTextFieldVisible,
                child: RoundedButton(
                  label: "Join",
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
