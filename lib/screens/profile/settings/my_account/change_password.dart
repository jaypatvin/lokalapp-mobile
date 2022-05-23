import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../models/app_navigator.dart';
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

    final _formField = useCallback(
      ({
        required FocusNode focusNode,
        required void Function(String) onChanged,
        String? Function(String?)? validator,
        String? errorText,
      }) {
        return TextFormField(
          focusNode: focusNode,
          autocorrect: false,
          obscureText: true,
          onChanged: onChanged,
          validator: validator,
          style: Theme.of(context)
              .textTheme
              .subtitle2
              ?.copyWith(color: Colors.black),
          decoration: InputDecoration(
            fillColor: Colors.white,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide.none,
            ),
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 21),
            errorMaxLines: 3,
            errorText: errorText,
          ),
        );
      },
      [],
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
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: KeyboardActions(
                config: _kbConfig,
                bottomAvoiderScrollPhysics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  onChanged: vm.onFormChanged,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 21),
                        child: Text(
                          'Old Password',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 4),
                      _formField(
                        focusNode: _oldPasswordFocusNode,
                        onChanged: vm.onOldPasswordChanged,
                        validator: vm.passwordValidator,
                        errorText: vm.signInError,
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.only(left: 21),
                        child: Text(
                          'New Password',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 4),
                      _formField(
                        focusNode: _newPasswordFocusNode,
                        onChanged: vm.onNewPasswordChanged,
                        validator: vm.passwordValidator,
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.only(left: 21),
                        child: Text(
                          'Confirm Password',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 4),
                      _formField(
                          focusNode: _confirmPasswordFocusNode,
                          onChanged: vm.onConfirmPasswordChanged,
                          errorText: vm.passwordMismatchError),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            width: double.maxFinite,
            child: AppButton.filled(
              text: 'Confirm',
              onPressed: () async {
                _confirmPasswordFocusNode.unfocus();
                _newPasswordFocusNode.unfocus();
                _oldPasswordFocusNode.unfocus();

                if (!(_formKey.currentState?.validate() ?? false)) return;

                final success = await performFuture<bool>(vm.onFormSubmit);
                if (success!) {
                  Navigator.push(
                    context,
                    AppNavigator.appPageRoute(
                      builder: (_) => const MyAccountConfirmation(
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
    );
  }
}
