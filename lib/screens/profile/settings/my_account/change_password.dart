import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../state/mvvm_builder.widget.dart';
import '../../../../state/views/hook.view.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../view_models/profile/settings/my_account/change_password.vm.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/overlays/screen_loader.dart';
import 'confirmation.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _ChangePasswordView(),
      viewModel: ChangePasswordViewModel(),
    );
  }
}

class _ChangePasswordView extends HookView<ChangePasswordViewModel>
    with HookScreenLoader {
  @override
  Widget screen(BuildContext context, ChangePasswordViewModel vm) {
    final _formKey = useMemoized<GlobalKey<FormState>>(
      () => GlobalKey<FormState>(),
    );

    final _oldPasswordFocusNode = useFocusNode();
    final _newPasswordFocusNode = useFocusNode();
    final _confirmPasswordFocusNode = useFocusNode();

    final _isMounted = useIsMounted();

    final _addPadding = useState(false);

    final _kbConfig = useMemoized<KeyboardActionsConfig>(
      () => KeyboardActionsConfig(
        keyboardBarColor: Colors.grey.shade200,
        actions: [
          KeyboardActionsItem(
            focusNode: _oldPasswordFocusNode,
          ),
          KeyboardActionsItem(
            focusNode: _newPasswordFocusNode,
          ),
          KeyboardActionsItem(
            focusNode: _confirmPasswordFocusNode,
          ),
        ],
      ),
    );

    useEffect(() {
      void listener() {
        _addPadding.value = _oldPasswordFocusNode.hasFocus ||
            _newPasswordFocusNode.hasFocus ||
            _confirmPasswordFocusNode.hasFocus;
      }

      _oldPasswordFocusNode.addListener(listener);
      _newPasswordFocusNode.addListener(listener);
      _confirmPasswordFocusNode.addListener(listener);

      return () {
        if (_isMounted()) {
          _oldPasswordFocusNode.removeListener(listener);
          _newPasswordFocusNode.removeListener(listener);
          _confirmPasswordFocusNode.removeListener(listener);
        }
      };
    }, [
      _oldPasswordFocusNode,
      _newPasswordFocusNode,
      _confirmPasswordFocusNode,
    ]);

    return Scaffold(
      backgroundColor: const Color(0xffF1FAFF),
      appBar: const CustomAppBar(
        titleText: 'Change Password',
        backgroundColor: kTealColor,
        titleStyle: TextStyle(color: Colors.white),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0.w, 20.0.h, 20.0.w, 0),
                child: KeyboardActions(
                  config: _kbConfig,
                  bottomAvoiderScrollPhysics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    onChanged: vm.onFormChanged,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Old Password',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        TextFormField(
                          focusNode: _oldPasswordFocusNode,
                          autocorrect: false,
                          obscureText: true,
                          onChanged: vm.onOldPasswordChanged,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0.sp,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0.r)),
                              borderSide: BorderSide.none,
                            ),
                            isDense: false,
                            filled: true,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16.0.w),
                            errorMaxLines: 3,
                            errorText: vm.signInError,
                          ),
                        ),
                        SizedBox(
                          height: 15.0.h,
                        ),
                        Text(
                          'New Password',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        TextFormField(
                          focusNode: _newPasswordFocusNode,
                          autocorrect: false,
                          obscureText: true,
                          validator: vm.passwordValidator,
                          onChanged: vm.onNewPasswordChanged,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0.sp,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0.r)),
                              borderSide: BorderSide.none,
                            ),
                            isDense: false,
                            filled: true,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16.0.w),
                            errorMaxLines: 3,
                          ),
                        ),
                        SizedBox(
                          height: 15.0.h,
                        ),
                        Text(
                          'Confirm Password',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        TextFormField(
                          focusNode: _confirmPasswordFocusNode,
                          autocorrect: false,
                          obscureText: true,
                          // validator: vm.passwordValidator,
                          onChanged: vm.onConfirmPasswordChanged,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0.sp,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0.r)),
                              borderSide: BorderSide.none,
                            ),
                            isDense: false,
                            filled: true,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16.0.w),
                            errorMaxLines: 3,
                            errorText: vm.passwordMismatchError,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              width: double.maxFinite,
              child: AppButton.filled(
                'Confirm',
                color: kTealColor,
                onPressed: () async {
                  _confirmPasswordFocusNode.unfocus();
                  _newPasswordFocusNode.unfocus();
                  _oldPasswordFocusNode.unfocus();

                  if (!(_formKey.currentState?.validate() ?? false)) return;

                  final success = await performFuture<bool>(vm.onFormSubmit);
                  if (success!) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyAccountConfirmation(
                          isPassword: true,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _addPadding.value ? kKeyboardActionHeight : 0,
            ),
            // const SizedBox(height: kKeyboardActionHeight),
          ],
        ),
      ),
    );
  }
}
