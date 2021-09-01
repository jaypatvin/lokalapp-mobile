import 'package:flutter/material.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:lokalapp/widgets/app_button.dart';
import 'package:validators/validators.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthInputForm extends StatelessWidget {
  final Key formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final void Function() onFormChanged;
  final void Function() onFormSubmit;
  final bool displaySignInError;
  final String submitButtonLabel;
  const AuthInputForm({
    Key key,
    this.formKey,
    this.emailController,
    this.passwordController,
    this.onFormChanged,
    this.onFormSubmit,
    this.displaySignInError = false,
    this.submitButtonLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: onFormChanged,
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            style: TextStyle(fontWeight: FontWeight.w500),
            decoration: new InputDecoration(
              border: new OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0.r)),
                borderSide: BorderSide.none,
              ),
              filled: true,
              alignLabelWithHint: true,
              hintText: "Email",
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0.w),
              errorStyle: TextStyle(
                color: kPinkColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            validator: (email) => isEmail(email) ? null : "Enter a valid email",
          ),
          SizedBox(height: 15.0.h),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            controller: passwordController,
            style: TextStyle(fontWeight: FontWeight.w500),
            decoration: new InputDecoration(
              border: new OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0.r)),
                borderSide: BorderSide.none,
              ),
              filled: true,
              alignLabelWithHint: true,
              hintText: "Password",
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0.w),
              errorStyle: TextStyle(
                color: kPinkColor,
                fontWeight: FontWeight.w500,
              ),
              errorText: displaySignInError
                  ? "The email and password combination is incorrect."
                  : null,
            ),
          ),
          SizedBox(height: 15.0.h),
          SizedBox(
            width: 130.0.w,
            child: AppButton(
              submitButtonLabel,
              emailController.text.isEmpty || passwordController.text.isEmpty
                  ? kTealColor
                  : kOrangeColor,
              true,
              onFormSubmit,
              textStyle: TextStyle(color: kNavyColor),
            ),
          )
        ],
      ),
    );
  }
}
