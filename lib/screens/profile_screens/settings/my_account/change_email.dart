import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../providers/user.dart';
import '../../../../providers/user_auth.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import 'components/email_input_form.dart';
import 'view_model/change_email.vm.dart';

class ChangeEmail extends StatefulWidget {
  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  late final ChangeEmailViewModel _viewModel;
  late final StreamSubscription<String> _errorSubscription;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _newEmail = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = ChangeEmailViewModel(
      context.read<UserAuth>(),
      context.read<CurrentUser>().user!,
    );
    _email.addListener(_onEmailChanged);
    _newEmail.addListener(_onNewEmailChanged);
    _password.addListener(_onPasswordChanged);
    _errorSubscription = _viewModel.errorStream.listen((event) {
      if (this.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(event)),
        );
      }
    });
  }

  @override
  void dispose() {
    _email.removeListener(_onEmailChanged);
    _newEmail.removeListener(_onNewEmailChanged);
    _password.removeListener(_onPasswordChanged);
    _errorSubscription.cancel();
    _viewModel.dispose();
    super.dispose();
  }

  void _onEmailChanged() => _viewModel.onEmailChanged(_email.text);
  void _onNewEmailChanged() => _viewModel.onNewEmailChanged(_newEmail.text);
  void _onPasswordChanged() => _viewModel.onPasswordChanged(_password.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kInviteScreenColor,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        titleText: 'Change Email Address',
        backgroundColor: kTealColor,
        leadingColor: Colors.white,
        titleStyle: TextStyle(color: Colors.white),
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: ChangeNotifierProvider<ChangeEmailViewModel>.value(
        value: _viewModel,
        builder: (ctx, _) {
          return Consumer<ChangeEmailViewModel>(builder: (ctx2, viewModel, _) {
            return Padding(
              padding: EdgeInsets.fromLTRB(20.0.w, 20.0.h, 20.0.w, 0),
              child: Column(
                children: [
                  Expanded(
                    child: EmailInputForm(
                      formKey: _formKey,
                      onEmailChanged: viewModel.onEmailChanged,
                      displayEmailMatchError: viewModel.displayEmailError,
                      emailController: _email,
                      newEmailController: _newEmail,
                      passwordController: _password,
                      onFormSubmit: viewModel.onFormSubmit,
                    ),
                  ),
                  if (viewModel.displayEmailError)
                    Text(
                      'Email addresses do not match!',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: kPinkColor),
                    ),
                  SizedBox(height: 20.0.h),
                  SizedBox(
                    width: double.maxFinite,
                    child: AppButton(
                      "Confirm",
                      kTealColor,
                      true,
                      viewModel.onFormSubmit,
                    ),
                  ),
                  // AnimatedContainer(
                  //   duration: const Duration(milliseconds: 200),
                  //   height: MediaQuery.of(context).viewInsets.bottom > 0
                  //       ? kKeyboardActionHeight
                  //       : 0,
                  // ),
                  const SizedBox(height: kKeyboardActionHeight),
                ],
              ),
            );
          });
        },
      ),
    );
  }
}
