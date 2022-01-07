import 'package:flutter/material.dart';

import '../../../../utils/constants/themes.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/inputs/input_password_field.dart';
import 'confirmation.dart';

class ChangePassword extends StatelessWidget {
  final TextEditingController oldPwController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();
  final TextEditingController newPwController = TextEditingController();

  final bool confirmed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1FAFF),
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(
        titleText: 'Change Password',
        backgroundColor: kTealColor,
        titleStyle: TextStyle(color: Colors.white),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 25,
          ),
          Text(
            'Old Password',
            style: Theme.of(context).textTheme.subtitle2,
          ),
          // buildInput(context, oldPwController),
          const InputPasswordField(
            hintText: '',
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'New Password',
            style: Theme.of(context).textTheme.subtitle2,
          ),
          const InputPasswordField(
            hintText: '',
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Confirm Password',
            style: Theme.of(context).textTheme.subtitle2,
          ),
          const InputPasswordField(
            hintText: '',
          ),

          AppButton.filled(
            'Confirm',
            color: kTealColor,
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
          )
        ],
      ),
    );
  }
}
