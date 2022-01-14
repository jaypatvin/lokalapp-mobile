import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../../utils/constants/themes.dart';
import '../../../../../widgets/inputs/input_email_field.dart';
import '../../../../../widgets/inputs/input_password_field.dart';

class EmailInputForm extends StatefulWidget {
  final Key? formKey;
  final TextEditingController? newEmailController;
  final TextEditingController? confirmEmailController;
  final TextEditingController? passwordController;
  final void Function()? onFormChanged;
  final void Function()? onFormSubmit;
  final void Function(String)? onNewEmailChanged;
  final void Function(String)? onConfirmEmailChanged;
  final void Function(String)? onPasswordChanged;
  final bool displaySignInError;
  final bool displayEmailMatchError;
  final FocusNode? newEmailFocusNode;
  final FocusNode? confirmEmailFocusNode;
  final FocusNode? passwordFocusNode;

  const EmailInputForm({
    Key? key,
    this.formKey,
    this.newEmailController,
    this.confirmEmailController,
    this.passwordController,
    this.onFormChanged,
    this.onFormSubmit,
    this.displaySignInError = false,
    this.displayEmailMatchError = false,
    this.onNewEmailChanged,
    this.onConfirmEmailChanged,
    this.onPasswordChanged,
    this.newEmailFocusNode,
    this.confirmEmailFocusNode,
    this.passwordFocusNode,
  }) : super(key: key);

  @override
  State<EmailInputForm> createState() => _EmailInputFormState();
}

class _EmailInputFormState extends State<EmailInputForm> {
  late final FocusNode _nodeNewEmail;
  late final FocusNode _nodeConfirmEmail;
  late final FocusNode _nodePassword;
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _nodeNewEmail = widget.newEmailFocusNode ?? FocusNode();
    _nodeConfirmEmail = widget.confirmEmailFocusNode ?? FocusNode();
    _nodePassword = widget.passwordFocusNode ?? FocusNode();
  }

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardBarColor: Colors.grey.shade200,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeNewEmail,
        ),
        KeyboardActionsItem(
          focusNode: _nodeConfirmEmail,
        ),
        KeyboardActionsItem(
          focusNode: _nodePassword,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      bottomAvoiderScrollPhysics: const ScrollPhysics(),
      config: _buildConfig(),
      child: Form(
        onChanged: widget.onFormChanged,
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Email Address',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            InputEmailField(
              focusNode: _nodeNewEmail,
              controller: widget.newEmailController,
              onChanged: widget.onNewEmailChanged,
              validate: true,
            ),
            SizedBox(height: 15.0.h),
            Text(
              'Confirm Email Address',
              style: widget.displayEmailMatchError
                  ? Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: kPinkColor)
                  : Theme.of(context).textTheme.bodyText1,
            ),
            InputEmailField(
              focusNode: _nodeConfirmEmail,
              controller: widget.confirmEmailController,
              onChanged: widget.onConfirmEmailChanged,
              displayErrorBorder: widget.displayEmailMatchError,
              validate: true,
            ),
            SizedBox(height: 15.0.h),
            Text(
              'Password',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            InputPasswordField(
              focusNode: _nodePassword,
              controller: widget.passwordController,
              onChanged: widget.onPasswordChanged,
              isPasswordVisible: _passwordVisible,
              displaySignInError: widget.displaySignInError,
              
              onPasswordVisibilityChanged: () =>
                  setState(() => _passwordVisible = !_passwordVisible),
            ),
          ],
        ),
      ),
    );
  }
}
