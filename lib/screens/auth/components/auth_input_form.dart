import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:validators/validators.dart';

import '../../../utils/themes.dart';
import '../../../widgets/app_button.dart';

class AuthInputForm extends StatefulWidget {
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
  _AuthInputFormState createState() => _AuthInputFormState();
}

class _AuthInputFormState extends State<AuthInputForm> {
  bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: widget.onFormChanged,
      key: widget.formKey,
      child: Column(
        children: [
          SizedBox(
            child: TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              controller: widget.emailController,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0.sp,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0.r)),
                  borderSide: BorderSide.none,
                ),
                isDense: false,
                filled: true,
                alignLabelWithHint: true,
                hintText: "Email",
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0.w),
              ),
              validator: (email) =>
                  isEmail(email) ? null : "Enter a valid email",
            ),
          ),
          SizedBox(height: 15.0.h),
          SizedBox(
            child: TextFormField(
              autocorrect: false,
              obscureText: !_passwordVisible,
              controller: widget.passwordController,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0.sp,
              ),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0.r)),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: kOrangeColor,
                  ),
                  onPressed: () {
                    setState(() => _passwordVisible = !_passwordVisible);
                  },
                ),
                isDense: false,
                filled: true,
                alignLabelWithHint: true,
                hintText: "Password",
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0.w),
                errorText: widget.displaySignInError
                    ? "The email and password combination is incorrect."
                    : null,
              ),
            ),
          ),
          SizedBox(height: 15.0.h),
          SizedBox(
            width: 130.0.w,
            child: AppButton(
              widget.submitButtonLabel,
              widget.emailController.text.isEmpty ||
                      widget.passwordController.text.isEmpty
                  ? kTealColor
                  : kOrangeColor,
              true,
              widget.onFormSubmit,
              textStyle: TextStyle(color: kNavyColor),
            ),
          )
        ],
      ),
    );
  }
}
