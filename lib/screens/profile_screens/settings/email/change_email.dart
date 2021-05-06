import 'package:flutter/material.dart';
import 'package:lokalapp/models/lokal_user.dart';
import 'package:lokalapp/screens/profile_screens/settings/email/email_changed.dart';
import 'package:lokalapp/utils/themes.dart';

class ChangeEmail extends StatelessWidget {
  TextEditingController newEmailController = TextEditingController();
  TextEditingController confirmEmailController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  bool confirmed = false;

  buildInput(context, controller) {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.5,
      padding: const EdgeInsets.only(top: 6, left: 30, right: 30),
      // height: MediaQuery.of(context).size.height * 0.5,
      child: TextFormField(
        controller: controller,
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

  // updateEmail(){
  //   LokalUser user = LokalUser()
  // }

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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EmailChanged()));
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
              buildInput(context, newEmailController),
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
              buildInput(context, confirmEmailController),
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
              buildInput(context, pwController),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              buildButton(context)
            ]));
  }
}
