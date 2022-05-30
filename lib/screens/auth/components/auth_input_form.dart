import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:validators/validators.dart';

import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';

class AuthInputForm extends StatefulWidget {
  final Key? formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
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
    required this.emailController,
    required this.passwordController,
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
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: Colors.black),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide.none,
                  ),
                  isDense: false,
                  filled: true,
                  alignLabelWithHint: true,
                  hintText: 'Email',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                  errorText: widget.emailInputError,
                ),
                validator: (email) =>
                    isEmail(email!) ? null : 'Enter a valid email',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              child: TextFormField(
                focusNode: _nodeTextPassword,
                autocorrect: false,
                obscureText: !_passwordVisible,
                controller: widget.passwordController,
                validator: widget.passwordValidator,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: Colors.black),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                  errorMaxLines: 3,
                  errorText: widget.passwordInputError,
                ),
              ),
            ),
            const SizedBox(height: 30),
            AppButton.filled(
              text: widget.submitButtonLabel ?? '',
              textStyle: const TextStyle(color: kNavyColor),
              width: 168,
              color: widget.emailController.text.isEmpty ||
                      widget.passwordController.text.isEmpty
                  ? kTealColor
                  : kOrangeColor,
              onPressed: () {
                _nodeTextEmail.unfocus();
                _nodeTextPassword.unfocus();
                widget.onFormSubmit?.call();
              },
            )
          ],
        ),
      ),
    );
  }
}
