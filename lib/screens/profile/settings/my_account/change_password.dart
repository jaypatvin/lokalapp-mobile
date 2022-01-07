import 'package:flutter/material.dart';

import '../../../../utils/constants/themes.dart';
import 'confirmation.dart';

class ChangePassword extends StatelessWidget {
  final TextEditingController oldPwController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();
  final TextEditingController newPwController = TextEditingController();

  final bool confirmed = false;

  Widget buildInput(BuildContext context, TextEditingController controller) {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.5,
      padding: const EdgeInsets.only(top: 6, left: 30, right: 30),
      // height: MediaQuery.of(context).size.height * 0.5,
      child: TextFormField(
        controller: controller,
        decoration: const InputDecoration(
          fillColor: Colors.white,
          filled: true,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 13,
          ),
          hintText: '',
          hintStyle: TextStyle(
            fontFamily: 'Goldplay',
            fontSize: 14,
            color: Colors.white,
            // fontWeight: FontWeight.w500
          ),
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(
                30.0,
              ),
            ),
          ),
          errorText: '',
        ),
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontFamily: 'Goldplay',
          fontSize: 20.0,
          // fontWeight: FontWeight.w500
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context) => Container(
        height: 43,
        width: 190,
        padding: const EdgeInsets.all(2),
        child: FlatButton(
          color: confirmed ? Colors.grey : kTealColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: const BorderSide(color: kTealColor),
          ),
          textColor: Colors.black,
          child: const Text(
            'Confirm',
            style: TextStyle(
              fontFamily: 'Goldplay',
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyAccountConfirmation(
                  isPassword: true,
                ),
              ),
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1FAFF),
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 100),
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
            ],
          ),
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Container(
            decoration: const BoxDecoration(color: kTealColor),
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_sharp,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  const Text(
                    'Change Password',
                    style: TextStyle(
                      fontFamily: 'Goldplay',
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
          const SizedBox(
            height: 25,
          ),
          Container(
            padding: const EdgeInsets.only(left: 40, bottom: 5),
            child: const Text(
              'Old Password',
              style: TextStyle(
                fontFamily: 'GoldplayBold',
                fontSize: 14,
              ),
            ),
          ),
          buildInput(context, oldPwController),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 40, bottom: 5),
            child: const Text(
              'New Password',
              style: TextStyle(
                fontFamily: 'GoldplayBold',
                fontSize: 14,
              ),
            ),
          ),
          buildInput(context, newPwController),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 40, bottom: 5),
            child: const Text(
              'Confirm Password',
              style: TextStyle(
                fontFamily: 'GoldplayBold',
                fontSize: 14,
              ),
            ),
          ),
          buildInput(context, confirmPwController),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          buildButton(context)
        ],
      ),
    );
  }
}
