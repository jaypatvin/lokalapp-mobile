import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:validators/validators.dart';

import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';

class AuthInputForm extends StatefulWidget {
  final Key? formKey;
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final void Function()? onFormChanged;
  final void Function()? onFormSubmit;
  final String? submitButtonLabel;
  final String? Function(String?)? passwordValidator;
  final FocusNode? emailFocusNode;
  final FocusNode? passwordFocusNode;
  final String? emailInputError;
  final String? passwordInputError;
  const AuthInputForm({
    Key? key,
    this.formKey,
    this.emailController,
    this.passwordController,
    this.onFormChanged,
    this.onFormSubmit,
    this.submitButtonLabel,
    this.passwordValidator,
    this.emailFocusNode,
    this.passwordFocusNode,
    this.emailInputError,
    this.passwordInputError,
  }) : super(key: key);

  @override
  _AuthInputFormState createState() => _AuthInputFormState();
}

class _AuthInputFormState extends State<AuthInputForm> {
  late final FocusNode _nodeTextEmail;
  late final FocusNode _nodeTextPassword;
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _nodeTextEmail = widget.emailFocusNode ?? FocusNode();
    _nodeTextPassword = widget.passwordFocusNode ?? FocusNode();
    _passwordVisible = false;
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardBarColor: Colors.grey.shade200,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeTextEmail,
          toolbarButtons: [
            (node) {
              return TextButton(
                onPressed: () => node.unfocus(),
                child: Text(
                  'Done',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.black,
                      ),
                ),
              );
            },
          ],
        ),
        KeyboardActionsItem(
          focusNode: _nodeTextPassword,
          toolbarButtons: [
            (node) {
              return TextButton(
                onPressed: () => node.unfocus(),
                child: Text(
                  'Done',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.black,
                      ),
                ),
              );
            },
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      disableScroll: true,
      config: _buildConfig(context),
      child: Form(
        onChanged: widget.onFormChanged,
        key: widget.formKey,
        child: Column(
          children: [
            SizedBox(
              child: TextFormField(
                focusNode: _nodeTextEmail,
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
                  hintText: 'Email',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  errorText: widget.emailInputError,
                ),
                validator: (email) =>
                    isEmail(email!) ? null : 'Enter a valid email',
              ),
            ),
            SizedBox(height: 15.0.h),
            SizedBox(
              child: TextFormField(
                focusNode: _nodeTextPassword,
                autocorrect: false,
                obscureText: !_passwordVisible,
                controller: widget.passwordController,
                validator: widget.passwordValidator,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0.sp,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0.r)),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: kOrangeColor,
                    ),
                    onPressed: () {
                      setState(() => _passwordVisible = !_passwordVisible);
                    },
                  ),
                  isDense: false,
                  filled: true,
                  alignLabelWithHint: true,
                  hintText: 'Password',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  errorMaxLines: 3,
                  errorText: widget.passwordInputError,
                ),
              ),
            ),
            SizedBox(height: 15.0.h),
            SizedBox(
              width: 130.0.w,
              child: AppButton(
                widget.submitButtonLabel,
                widget.emailController!.text.isEmpty ||
                        widget.passwordController!.text.isEmpty
                    ? kTealColor
                    : kOrangeColor,
                true,
                () {
                  _nodeTextEmail.unfocus();
                  _nodeTextPassword.unfocus();
                  widget.onFormSubmit?.call();
                },
                textStyle: const TextStyle(color: kNavyColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
