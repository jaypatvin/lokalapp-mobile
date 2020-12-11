import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/screens/community.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:lokalapp/widgets/rounded_button.dart';

class InvitePage extends StatefulWidget {
  static const String id = 'invite_page';
  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _inviteCode;
  TextEditingController _inviteCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _inviteCodeController.addListener(() {
      this._inviteCode = _inviteCodeController.text;
    });
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
                controller: _inviteCodeController,
                style: TextStyle(
                  fontFamily: "Goldplay",
                  fontWeight: FontWeight.bold,
                ),
                decoration: _kInputDecoration.copyWith(
                  hintText: "Community Key",
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(
                height: 35.0,
              ),
              RoundedButton(
                label: "Join",
                onPressed: () async {
                  final DocumentSnapshot snapshot = await _firestore
                      .collection('invites')
                      .doc(_inviteCode)
                      .get();
                  if (snapshot.exists) {
                    debugPrint('SnapshotID is ${snapshot.id}');
                    debugPrint('InviteCode is $_inviteCode');
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Community()),
                      (route) => false,
                    );
                  }
                  debugPrint('Community Key not found');
                },
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
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
