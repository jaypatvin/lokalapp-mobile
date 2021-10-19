import 'package:flutter/material.dart';
import '../../../../providers/post_requests/auth_body.dart';
import '../../../../providers/user.dart';
import 'email_changed.dart';
import '../../../../services/database.dart';
import '../../../../utils/constants/themes.dart';
import 'package:provider/provider.dart';

class ChangeEmail extends StatefulWidget {
  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  String? newEmail;

  String? confirmEmail;

  String? pw;

  bool confirmed = false;

  Future updateEmail() async {
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    AuthBody authBody = Provider.of<AuthBody>(context, listen: false);

    try {
      authBody.update(email: newEmail);
      await usersRef.doc(currentUser.id).update({'email': newEmail});
      Navigator.pop(context);
    } on Exception catch (_) {
      print(_);
    }
  }

  buildInput(context, Function onChanged, bool obscureText) {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.5,
      padding: const EdgeInsets.only(top: 6, left: 30, right: 30),
      // height: MediaQuery.of(context).size.height * 0.5,
      child: TextFormField(
        obscureText: obscureText,
        onChanged: onChanged as void Function(String)?,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 13,
          ),
          hintText: '',
          hintStyle: TextStyle(
            fontFamily: "GoldplayBold",
            fontSize: 14,
            color: Colors.white,
            // fontWeight: FontWeight.w500
          ),
          alignLabelWithHint: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: const BorderRadius.all(
              Radius.circular(
                30.0,
              ),
            ),
          ),
          errorText: '',
        ),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontFamily: "GoldplayBold",
          fontSize: 20.0,
          // fontWeight: FontWeight.w500
        ),
      ),
    );
  }

  buildButton(context) => Container(
        height: 43,
        width: 190,
        padding: const EdgeInsets.all(2),
        child: FlatButton(
          color: confirmed ? Colors.grey : kTealColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: kTealColor),
          ),
          textColor: Colors.black,
          child: Text(
            "Confirm",
            style: TextStyle(
                fontFamily: "Goldplay",
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            try {
              if (newEmail == confirmEmail) {
                updateEmail();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EmailChanged()));
              }
            } catch (e) {}
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF1FAFF),
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 100),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
              ],
            ),
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Container(
              decoration: BoxDecoration(color: kTealColor),
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_sharp,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Container(
                      // padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Change Email Address",
                        style: TextStyle(
                            fontFamily: "Goldplay",
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: ListView(
            // shrinkWrap: true,
            children: [
              SizedBox(
                height: 25,
              ),
              Container(
                  padding: const EdgeInsets.only(left: 40, bottom: 5),
                  child: Text(
                    "New Email Address",
                    style: TextStyle(
                      fontFamily: "GoldplayBold",
                      fontSize: 14,
                    ),
                  )),
              buildInput(context, (value) {
                setState(() {
                  newEmail = value;
                });
              }, false),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.only(left: 40, bottom: 5),
                  child: Text(
                    "Confirm Email Address",
                    style: TextStyle(
                      fontFamily: "GoldplayBold",
                      fontSize: 14,
                    ),
                  )),
              buildInput(context, (value) {
                setState(() {
                  confirmEmail = value;
                });
              }, false),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.only(left: 40, bottom: 5),
                  child: Text(
                    "Password",
                    style: TextStyle(
                      fontFamily: "GoldplayBold",
                      fontSize: 14,
                    ),
                  )),
              buildInput(context, (value) {
                setState(() {
                  pw = value;
                });
              }, true),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              buildButton(context)
            ]));
  }
}
