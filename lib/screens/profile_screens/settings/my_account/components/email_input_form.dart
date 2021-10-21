import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lokalapp/utils/constants/themes.dart';

import '../../../../../widgets/email_input_field.dart';
import '../../../../../widgets/password_input_field.dart';

class EmailInputForm extends StatefulWidget {
  final Key? formKey;
  final TextEditingController? emailController;
  final TextEditingController? newEmailController;
  final TextEditingController? passwordController;
  final void Function()? onFormChanged;
  final void Function()? onFormSubmit;
  final void Function(String)? onEmailChanged;
  final void Function(String)? onNewEmailChanged;
  final void Function(String)? onPasswordChanged;
  final bool displaySignInError;
  final bool displayEmailMatchError;
  const EmailInputForm({
    Key? key,
    this.formKey,
    this.emailController,
    this.newEmailController,
    this.passwordController,
    this.onFormChanged,
    this.onFormSubmit,
    this.displaySignInError = false,
    this.displayEmailMatchError = false,
    this.onEmailChanged,
    this.onNewEmailChanged,
    this.onPasswordChanged,
  }) : super(key: key);

  @override
  State<EmailInputForm> createState() => _EmailInputFormState();
}

class _EmailInputFormState extends State<EmailInputForm> {
  final FocusNode _nodeEmail = FocusNode();
  final FocusNode _nodeNewEmail = FocusNode();
  final FocusNode _nodePassword = FocusNode();
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey.shade200,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeEmail,
          toolbarButtons: [
            (node) {
              return TextButton(
                onPressed: () => node.unfocus(),
                child: Text(
                  "Done",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.black,
                      ),
                ),
              );
            },
          ],
        ),
        KeyboardActionsItem(
          focusNode: _nodeNewEmail,
          toolbarButtons: [
            (node) {
              return TextButton(
                onPressed: () => node.unfocus(),
                child: Text(
                  "Done",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.black,
                      ),
                ),
              );
            },
          ],
        ),
        KeyboardActionsItem(
          focusNode: _nodePassword,
          toolbarButtons: [
            (node) {
              return TextButton(
                onPressed: () => node.unfocus(),
                child: Text(
                  "Done",
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
      bottomAvoiderScrollPhysics: ScrollPhysics(),
      config: _buildConfig(context),
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
            EmailInputField(
              focusNode: _nodeEmail,
              controller: widget.emailController,
              onChanged: widget.onEmailChanged,
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
            EmailInputField(
              focusNode: _nodeNewEmail,
              controller: widget.newEmailController,
              onChanged: widget.onNewEmailChanged,
              displayErrorBorder: widget.displayEmailMatchError,
            ),
            SizedBox(height: 15.0.h),
            Text(
              'Password',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            PasswordInputField(
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
